//
//  ContatosViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class ContatosTableViewController: UITableViewController {

    var contatos: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        downloadJson()
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
        return contatos.count
    }

// swiftlint:disable force_cast
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContatoTableViewCell", owner: self, options: nil)?.first as! ContatoTableViewCell

        cell.username.text = contatos[indexPath.row].username
        cell.name.text = contatos[indexPath.row].name

        if let imagemURL = URL(string: contatos[indexPath.row].img) {
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

    func loadContatos() {
        contatos = contatos.sorted { (contato1, contato2) -> Bool in
            let contatoNome1: String = contato1.name
            let contatoNome2: String = contato2.name
            return (contatoNome1.localizedCaseInsensitiveCompare(contatoNome2) == .orderedAscending)
        }
         tableView.reloadData()
    }
// swiftlint:enable force_cast

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        76
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
