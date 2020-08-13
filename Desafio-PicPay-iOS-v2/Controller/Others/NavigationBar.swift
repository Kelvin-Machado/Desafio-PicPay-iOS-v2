//
//  NavigationBar.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false

    }

    func setupNewNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
            let customBackButton = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                                   style: .plain, target: self,
                                                   action: #selector(backAction(sender:)))
            customBackButton.imageInsets = UIEdgeInsets(top: 2, left: -8, bottom: 0, right: 0)
            navigationItem.leftBarButtonItem = customBackButton
        }
        @objc func backAction(sender: UIBarButtonItem) {
            _ = navigationController?.popToRootViewController(animated: true)
    }
}
