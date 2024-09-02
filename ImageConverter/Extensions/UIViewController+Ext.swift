//
//  UIViewController+Ext.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 30/8/2024.
//

import UIKit

extension UIViewController {
    func initNavBar(with title: String) {
        navigationController?.setNavBarTranslucent()
        navigationItem.title = "Image Converter"
    }
}
