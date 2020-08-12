//
//  CreditCard.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation
import RealmSwift

class CreditCard: Object {
    @objc dynamic var Id: Int = 0
    @objc dynamic var numCartao: String = ""
    @objc dynamic var cvv: Int = 0
    @objc dynamic var vencimento: Date?
    @objc dynamic var nomeTitular: String = ""
    override static func primaryKey() -> String? {
        return "Id"
    }
}
