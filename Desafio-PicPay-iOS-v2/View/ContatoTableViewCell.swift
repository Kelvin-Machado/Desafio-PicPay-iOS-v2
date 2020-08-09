//
//  ContatoTableViewCell.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 09/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class ContatoTableViewCell: UITableViewCell {

    @IBOutlet weak var contatoImagem: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contatoImagem.layer.cornerRadius = 26
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
