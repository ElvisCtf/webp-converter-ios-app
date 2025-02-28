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
    private lazy var converterView = ConverterView(viewModel: viewModel)
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
        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage)),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(convertImage))
        ]
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    @objc func addImage() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.selection = .ordered
        config.filter = .images
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func convertImage() {
        viewModel.convertImages()
    }
}


// MARK: - TableView Delegate
extension ConverterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var index = 0
        for result in results {
            let itemProvider = result.itemProvider
            // Check image is WebP
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.webP.identifier) {
                // Convert WebP image into data object
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.webP.identifier) { data, error in
                    guard error == nil else { return }
                    self.viewModel.imageTasks.append(ImageTaskModel(index: index, filename: itemProvider.suggestedName ?? "", inputData: data, outputFormat: .PNG))
                    index+=1
                    self.converterView.reloadTable()
                }
            }
        }
    }
}
