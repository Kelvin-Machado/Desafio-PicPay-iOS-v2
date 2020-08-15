//
//  Transaction.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 15/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    let transaction: TransactionClass
}

struct TransactionClass: Decodable {
    let success: Bool
    let id, timestamp: Int
    let value: Double
    let destinationUser: DestinationUser
    let status: String

    enum CodingKeys: String, CodingKey {
        case success, id, timestamp, value
        case destinationUser = "destination_user"
        case status
    }
}
struct DestinationUser: Decodable {
    let username: String
    let id: Int
    let img: String
    let name: String
}
