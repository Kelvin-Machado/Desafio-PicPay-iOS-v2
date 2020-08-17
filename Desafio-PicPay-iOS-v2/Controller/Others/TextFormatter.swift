//
//  TextFormatter.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 12/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

extension CadastrarCCViewController {

// MARK: - Formata espaços entre números do cartão de crédito
    func modifyCreditCardString(creditCardString: String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if !(arrOfCharacters.isEmpty) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if (i+1) % 4 == 0 && i+1 != arrOfCharacters.count {
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }

    @objc func didChangeText(textField: UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newLength = (textField.text ?? "").count + string.count - range.length

//        Formata quantidade de digitos no cartão de crédito
        if textField == numCartao {
             return newLength <= 19
         }

//        Formata data de vencimento
               if textField == vencimento {
                   if vencimento.text?.count == 2 {
                       if !(string == "") {
                           vencimento.text = vencimento.text! + "/"
                       }
                   }
                   return !(textField.text!.count >= 5 && (string.count ) > range.length)
               }
//        Formats CVV
        if textField == cvv {
            return newLength <= 3
        } else {
            return true
        }
    }

}

extension String {

//     Formata texto para o campo de valores
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix =
            regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                          range: NSRange(location: 0, length: self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // se o primeiro número for zero, ou todos forem apagados
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}

extension String {
    func toDecimalWithAutoLocale() -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        formatter.locale = Locale(identifier: "pt_BR")

        if let number = formatter.number(from: self) {
           return number.decimalValue
        }
        return nil
    }

    func toDoubleWithAutoLocale() -> Double? {
        guard let decimal = self.toDecimalWithAutoLocale() else {
            return nil
        }
        return NSDecimalNumber(decimal: decimal).doubleValue
    }
}
extension UIViewController {
    func converteDataRealm(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +ssss"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM/yy"
        return dateFormatter.string(from: date!)
    }
}
