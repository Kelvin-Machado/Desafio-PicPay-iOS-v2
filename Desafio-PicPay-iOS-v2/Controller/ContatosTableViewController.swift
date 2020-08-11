//
//  ContatosViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift

class ContatosTableViewController: UITableViewController {

    let realm = try! Realm()
    var creditcard: Results<CreditCard>?

    var contatos: [Contact] = []
    var contatosFiltro: [Contact] = []
    var searching = false

    // MARK: - Inicialização

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        setupNavBarLarge()
    }

    // MARK: - Download JSON

    func downloadJson() {
        let contatosString = "http://careers.picpay.com/tests/mobdev/users"
        guard let url = URL(string: contatosString) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data else { return }

            do {
                let contatosBaixados = try
                    JSONDecoder().decode([Contact].self, from: data)
                self.contatos = contatosBaixados
                DispatchQueue.main.async {
                    self.loadContatos()
                }
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
        }.resume()
    }

    // MARK: - configurações da tabela

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contatosFiltro.count
    }

// swiftlint:disable force_cast
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContatoTableViewCell", owner: self, options: nil)?.first as! ContatoTableViewCell

        cell.username.text = contatosFiltro[indexPath.row].username
        cell.name.text = contatosFiltro[indexPath.row].name

        if let imagemURL = URL(string: contatosFiltro[indexPath.row].img) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imagemURL)
                if let data = data {
                    let imagem = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.contatoImagem.image = imagem
                    }
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if loadCreditCard() {
            print("CC registrado")
        } else {
            print("sem CC")
            performSegue(withIdentifier: "goToRegistroCC", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
// swiftlint:enable force_cast

    func loadContatos() {
        var contatosReload: [Contact] = []
        searching ? (contatosReload = contatosFiltro) : (contatosReload = contatos)

        contatosFiltro = contatosReload.sorted { (contato1, contato2) -> Bool in
            let contatoNome1: String = contato1.name
            let contatoNome2: String = contato2.name
            return (contatoNome1.localizedCaseInsensitiveCompare(contatoNome2) == .orderedAscending)
        }
         tableView.reloadData()
    }

    func loadCreditCard() -> Bool {
        creditcard = realm.objects(CreditCard.self)
        if creditcard!.isEmpty {
            return false
        } else {
            return true
        }
    }

    // MARK: - configurações da tela

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < -35 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - SearchBar

extension ContatosTableViewController: UISearchBarDelegate {

    func searchBar( _ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            searching = false
            loadContatos()
        } else {
            searching = true
            contatosFiltro = contatos.filter {
                $0.name.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
                $0.username.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
        loadContatos()
    }
}
