//
//  PagamentoViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 12/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PagamentoViewController: UIViewController, UITextFieldDelegate {

    static var nomeTela = ""

    let pagarBtn = UIButton()
    let realm = try! Realm()
    var creditCard: Results<CreditCard>?

    @IBOutlet weak var imagemContatoPagar: UIImageView!
    @IBOutlet weak var usernameContatoPagar: UILabel!
    @IBOutlet weak var simbolo: UILabel!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var editar: UIButton!

    var constraintBtnTop: NSLayoutConstraint!
    var constraintBtnBottom: NSLayoutConstraint!

    var imagem = ""
    var username = ""
    var idContato = 0

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
        PagamentoViewController.nomeTela = "telaCadastro"
    }

    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = valor.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }

    // MARK: - Informação do contato

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

    // MARK: - Configura botão

    func setupSaveButton() {
        pagarBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        pagarBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        pagarBtn.setTitle("Pagar", for: .normal)
        pagarBtn.addTarget(self, action: #selector(pagarBtnTapped), for: .touchUpInside)
        view.addSubview(pagarBtn)
        setsaveBtnConstraints()
    }

    @objc func pagarBtnTapped() {
        aproveTransactions()
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

extension PagamentoViewController {

    struct PaymentRequest: Encodable {
        var card_number: String!
        var cvv: Int!
        var value: Double!
        var expiry_date: String
        var destination_user_id: Int!
    }

    func aproveTransactions() {

        creditCard = realm.objects(CreditCard.self)
        let date = converteDataRealm(creditCard![0].vencimento!.description)
        
        var valorDouble = 0.0
        if  (Double(valor.text!) != nil) {
            valorDouble = Double(valor.text!)!
        }
        let parameters = PaymentRequest(card_number: creditCard?[0].numCartao.replacingOccurrences(of: " ", with: ""),
                                        cvv: creditCard![0].cvv,
                                        value: valorDouble,
                                        expiry_date: date,
                                    destination_user_id: idContato)

        AF.request("http://careers.picpay.com/tests/mobdev/transaction", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success:
                let status = "Aprovada"
                let dados = response.self.debugDescription
                print(dados)

//                if dados.contains(status){
//                    let recibo = ViewController()
//                    ViewController.reciboAppear = true
//                    self.navigationController?.pushViewController(recibo, animated: true)
//                }else{
//                    self.showAlert()
//                }

            case .failure:
                print("Erro")
            }

        }

    }

    func showAlert() {
        let alert = UIAlertController(title: "Oops!!!!", message: " Ocorreu um erro! \n Por favor, verifique os dados do Cartão de Crédito", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


              @unknown default:
                fatalError()
            }}))
        self.present(alert, animated: true, completion: nil)

//        let recibo = ContatosTableViewController
//        ViewController.reciboAppear = false
//        self.navigationController?.pushViewController(recibo, animated: true)
    }
    func converteDataRealm(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +ssss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM/yy"
        return dateFormatter.string(from: date!)
    }
}
