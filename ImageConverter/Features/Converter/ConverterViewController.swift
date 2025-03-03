//
//  ConverterViewController.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 27/8/2024.
//

import UIKit
import SnapKit
import PhotosUI

class ConverterViewController: UIViewController {
    private lazy var converterView = ConverterView(parentVC: self, viewModel: viewModel)
    private let viewModel = ConverterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        view = converterView
        initNavBar(with: Constants.appName)
        initToolBar()
    }
    
    private func initToolBar() {
        toolbarItems = converterView.toolbarItems
        navigationController?.setToolbarHidden(false, animated: false)
    }
}
