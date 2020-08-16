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
    static var reciboVC = ReciboViewController()

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
        setupBotaoPagar()
        valor.delegate = self
        valor.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.valor.becomeFirstResponder()
        }
        PagamentoViewController.nomeTela = "telaCadastro"
    }

    // MARK: - Configura cor do simbolo

    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = valor.text?.currencyInputFormatting() {
            textField.text = amountString
        }
        if valor.text == "" {
            simbolo.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        } else {
            simbolo.textColor = #colorLiteral(red: 0, green: 0.7665649056, blue: 0.3102965951, alpha: 1)
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

    func setupBotaoPagar() {
        pagarBtn.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 16)
        pagarBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        pagarBtn.setTitle("Pagar", for: .normal)
        pagarBtn.addTarget(self, action: #selector(pagarBtnTapped), for: .touchUpInside)
        view.addSubview(pagarBtn)
        setsaveBtnConstraints()
    }

    @objc func pagarBtnTapped() {
        pagamentoEfetuado()
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

// MARK: - Métodos POST
extension PagamentoViewController {

    struct PaymentRequest: Encodable {
        var card_number: String!
        var cvv: Int!
        var value: Double!
        var expiry_date: String
        var destination_user_id: Int!
    }

    func pagamentoEfetuado() {

        creditCard = realm.objects(CreditCard.self)
        let date = converteDataRealm(creditCard![0].vencimento!.description)

        let parameters: Parameters = [
            "card_number": creditCard![0].numCartao.replacingOccurrences(of: " ", with: ""),
            "cvv": creditCard![0].cvv,
            "value": valor.text!.toDecimalWithAutoLocale() ?? 0.0,
            "expiry_date": date,
            "destination_user_id": idContato
        ]

        let url = "http://careers.picpay.com/tests/mobdev/transaction"

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200 ..< 299).responseJSON { AFdata in

                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Erro: Não foi possível converter dados para JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        else {
                            print("Erro: Não pôde converter JSON object para Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Erro ao converter JSON em String")
                        return
                    }

                    let data = prettyPrintedJson.data(using: .utf8)!
                    do {
                        let transactionResponse = try JSONDecoder().decode(Transaction.self, from: data)
                        self.resultadoTransaction(contatoPagar: transactionResponse)
                    } catch {
                        print(error)
                    }
                } catch {
                    print("Error: Tentando converter JSON data para string")
                    return
                }
            }.self
    }

    func resultadoTransaction(contatoPagar: Transaction) {
        switch contatoPagar.transaction.success {
        case true:
            PagamentoViewController.reciboVC =
                (self.storyboard?.instantiateViewController(withIdentifier: "Recibo") as? ReciboViewController)!
            PagamentoViewController.reciboVC.dadosRecibo = contatoPagar
            navigationController?.popToRootViewController(animated: true)

        case false:
            showAlert()
        }
    }

    func showAlert() {
        let msg = "Ocorreu um erro! \n Por favor, verifique os dados do Cartão de Crédito"
        let alert = UIAlertController(title: "Oops!!!!", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style {
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
