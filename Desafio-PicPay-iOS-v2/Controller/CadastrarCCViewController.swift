//
//  CadastrarCCViewController.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 11/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CadastrarCCViewController: UIViewController {

    @IBOutlet weak var salvarBtn: UIButton!
    @IBOutlet weak var numCartao: SkyFloatingLabelTextField!
    @IBOutlet weak var nomeTitular: SkyFloatingLabelTextField!
    @IBOutlet weak var vencimento: SkyFloatingLabelTextField!
    @IBOutlet weak var cvv: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        salvarBtn.layer.cornerRadius = 25
    }

// MARK: - Keyboard

}
