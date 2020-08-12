//
//  PaymentViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 10/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

class RegistroCCViewController: UIViewController {

    @IBOutlet weak var CadastrarBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        CadastrarBtn.layer.cornerRadius = 25
    }
}
