//
//  ConverterViewController.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 27/8/2024.
//

import UIKit
import SnapKit
import PhotosUI

class ConverterViewController: UIViewController {
    
    let viewModel = ConverterViewModel()
    
    lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.resusableIdentifier)
        tv.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tv.backgroundColor = .systemGroupedBackground
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        view.backgroundColor = .systemBackground
        initNavBar(with: "Image Converter")
        initToolBar()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    func initToolBar() {
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
    
    @objc func convertImage() {
        for image in viewModel.tasks {
            guard let inputData = image.inputData,
                  let inputImage = UIImage(data: inputData)
            else { continue }
            
            let outputData = switch image.outputFormat {
            case .PNG:
                inputImage.pngData()
            case .JPG:
                inputImage.jpegData(compressionQuality: 1.0)
            }
            if let outputData, let outputImage = UIImage(data: outputData) {
                UIImageWriteToSavedPhotosAlbum(outputImage, nil, nil, nil)
            }
        }
    }
}


// MARK: TableView Delegate
extension ConverterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.resusableIdentifier, for: indexPath) as! TaskTableViewCell
        cell.row = indexPath.row
        cell.setString(filename: viewModel.tasks[indexPath.row].filename)
        cell.changeFormatCallBack = { row, imageFormat in
            self.viewModel.tasks[indexPath.row].outputFormat = imageFormat
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}


// MARK: TableView Delegate
extension ConverterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var images = [ImageModel]()
        
        for result in results {
            let itemProvider = result.itemProvider
            // Check image is WebP
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.webP.identifier) {
                // Convert WebP image into data object
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.webP.identifier) { data, error in
                    guard error == nil else { return }
                    DispatchQueue.main.async {
                        self.viewModel.tasks.append(ImageModel(filename: itemProvider.suggestedName ?? "", inputData: data, outputFormat: .PNG))
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
