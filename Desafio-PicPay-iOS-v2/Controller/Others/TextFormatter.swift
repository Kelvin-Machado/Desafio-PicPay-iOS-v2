//
//  TextFormatter.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 12/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

extension CadastrarCCViewController {

// MARK: - Formats Credit Card Number
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

//        Formats Credit Card Number Length
        if textField == numCartao {
             return newLength <= 19
         }

//        Formats Expiry Date
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
