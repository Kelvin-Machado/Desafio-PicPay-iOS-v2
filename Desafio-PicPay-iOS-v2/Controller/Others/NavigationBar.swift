//
//  NavigationBar.swift
//  Desafio-PicPay-iOS-v2
//
//  Created by Kelvin Batista Machado on 07/08/20.
//  Copyright © 2020 Kelvin Batista Machado. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavBarLarge() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backItem?.title = " "
        navigationController?.isNavigationBarHidden = false
    }
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.7958126664, blue: 0.3956114948, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1126654819, green: 0.117790021, blue: 0.1262878478, alpha: 1)
//        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backItem?.title = " "
    }
}
