//
//  PagamentoViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 12/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class PagamentoViewController: UIViewController, UITextFieldDelegate {

    let pagarBtn = UIButton()

    @IBOutlet weak var imagemContatoPagar: UIImageView!
    @IBOutlet weak var usernameContatoPagar: UILabel!
    @IBOutlet weak var simbolo: UILabel!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var editar: UIButton!

    var constraintBtnTop: NSLayoutConstraint!
    var constraintBtnBottom: NSLayoutConstraint!

    var imagem = ""
    var username = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewNavBar()
        carregaDados()
        setupSaveButton()
        valor.delegate = self
        valor.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.valor.becomeFirstResponder()
        }
    }

    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = valor.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }

    func carregaDados() {
        if let imagemURL = URL(string: imagem) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imagemURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imagemContatoPagar.image = image
                    }
                }
            }
        }
        imagemContatoPagar.layer.cornerRadius = 45
        usernameContatoPagar.text = username
    }

    func setupSaveButton() {
        pagarBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        pagarBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        pagarBtn.setTitle("Pagar", for: .normal)
//        pagarBtn.addTarget(self, action: #selector(pagarBtnTapped), for: .touchUpInside)
        view.addSubview(pagarBtn)
        setsaveBtnConstraints()
    }
    func  setsaveBtnConstraints() {

        pagarBtn.translatesAutoresizingMaskIntoConstraints = false
        pagarBtn.layer.cornerRadius = 25

        NSLayoutConstraint.activate([
            pagarBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pagarBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pagarBtn.heightAnchor.constraint(equalToConstant: 50)
        ])

        constraintBtnBottom = pagarBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        constraintBtnBottom.isActive = true
        constraintBtnTop = pagarBtn.topAnchor.constraint(equalTo: editar.bottomAnchor, constant: 30)
        constraintBtnTop.isActive = false
    }

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        constraintBtnBottom.isActive = false
        constraintBtnTop.isActive = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintBtnBottom.isActive = true
        constraintBtnTop.isActive = false
    }
}
