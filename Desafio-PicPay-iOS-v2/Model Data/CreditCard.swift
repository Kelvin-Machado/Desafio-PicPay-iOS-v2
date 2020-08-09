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
    @objc dynamic var cardNumb: String = ""
    @objc dynamic var cardNumbRaw: String = ""
    @objc dynamic var cvv: Int = 0
    @objc dynamic var expiryDate: String = ""
    @objc dynamic var expiryDateRaw: String = ""
    @objc dynamic var holderName: String = ""
}
