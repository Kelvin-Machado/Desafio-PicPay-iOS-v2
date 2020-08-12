//
//  CadastrarCCViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 11/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import RealmSwift
import SkyFloatingLabelTextField

class CadastrarCCViewController: UIViewController, UITextFieldDelegate {

    let saveBtn = UIButton()
    let realm = try! Realm()

    @IBOutlet weak var numCartao: SkyFloatingLabelTextField!
    @IBOutlet weak var nomeTitular: SkyFloatingLabelTextField!
    @IBOutlet weak var vencimento: SkyFloatingLabelTextField!
    @IBOutlet weak var cvv: SkyFloatingLabelTextField!

    var constraintBtnTop: NSLayoutConstraint!
    var constraintBtnBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        numCartao.delegate = self
        nomeTitular.delegate = self
        vencimento.delegate = self
        cvv.delegate = self

        numCartao.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        setupSaveButton()
    }
// MARK: - Métodos de manipulação de dados

    func save(creditcard: CreditCard) {
        do {

            try realm.write {
                if realm.isEmpty {
                    realm.add(creditcard)
                } else {
                    realm.add(creditcard, update: .modified)
                }
            }
        } catch {
            print("Error saving CreditCard \(error)")
        }
    }

// MARK: - Configura Botão

    func setupSaveButton() {
        saveBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        saveBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        saveBtn.setTitle("Salvar", for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
        view.addSubview(saveBtn)
        setsaveBtnConstraints()
    }
    @objc func saveBtnTapped() {
        let newCreditCard = CreditCard()
        newCreditCard.Id = 0
        newCreditCard.numCartao = numCartao.text!
        newCreditCard.nomeTitular = nomeTitular.text!
        newCreditCard.cvv = Int(cvv.text!)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        let enteredDate = dateFormatter.date(from: vencimento.text!)
        newCreditCard.vencimento = enteredDate

        self.save(creditcard: newCreditCard)
        print("Botão salvar pressionado")
    }

    func  setsaveBtnConstraints() {

        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.layer.cornerRadius = 25

        NSLayoutConstraint.activate([
            saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveBtn.heightAnchor.constraint(equalToConstant: 50)
        ])

        constraintBtnBottom = saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        constraintBtnBottom.isActive = true
        constraintBtnTop = saveBtn.topAnchor.constraint(equalTo: vencimento.bottomAnchor, constant: 30)
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
