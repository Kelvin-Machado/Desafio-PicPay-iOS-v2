//
//  ReciboViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 15/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class ReciboViewController: UIViewController {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var valorCartao: UILabel!
    @IBOutlet weak var valorTotal: UILabel!
    @IBOutlet weak var dataFormatada: UILabel!
    @IBOutlet weak var numeroTransacao: UILabel!

    var dadosRecibo: Transaction!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    func loadData() {
        let img = dadosRecibo.transaction.destinationUser.img
        if let imagemURL = URL(string: img) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imagemURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imagem.image = image
                        self.imagem.layer.cornerRadius = 60
                    }
                }
            }
        }
    }
    func getDate (timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let mounth = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return ("\(day)/\(mounth)/\(year) às \(hour):\(minute)")
    }
    // MARK: - Navigation
}
