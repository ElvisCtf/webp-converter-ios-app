//
//  UINavigationController+Ext.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 27/8/2024.
//

import UIKit

extension UINavigationController {
    func setNavBarTranslucent() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        self.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}
