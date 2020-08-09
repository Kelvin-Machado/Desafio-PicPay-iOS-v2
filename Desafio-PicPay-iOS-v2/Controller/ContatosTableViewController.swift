//
//  ContatosViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

struct ContatosTeste {
    let image: UIImage!
    let username: String!
    let name: String!
}

class ContatosTableViewController: UITableViewController {

    var contato: ContatosTeste!
    var arrayTeste = [ContatosTeste]()
    var aux = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        //teste
        while aux < 33 {
            contato = ContatosTeste(image: #imageLiteral(resourceName: "man"), username: "@contatoTeste \(aux + 1)", name: "Contato Teste \(aux + 1)")
            arrayTeste.append(contato)
            aux+=1
        }
    }

    // MARK: - configurações da tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTeste.count
    }
// swiftlint:disable all
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ContatoTableViewCell", owner: self, options: nil)?.first as! ContatoTableViewCell
        cell.contatoImagem.image = arrayTeste[indexPath.row].image
        cell.username.text = arrayTeste[indexPath.row].username
        cell.name.text = arrayTeste[indexPath.row].name
        return cell
    }
// swiftlint:enable all

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
