//
//  UINavigationController+Ext.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 27/8/2024.
//

import UIKit

extension UINavigationController {
    func setNavBarTranslucent() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        self.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    func enableNavBarLargeTitle() {
        self.navigationBar.prefersLargeTitles = true
    }
}
