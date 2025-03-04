//
//  ConverterView.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 2/9/2024.
//

import UIKit
import SnapKit
import RxSwift
import PhotosUI

final class ConverterView: UIView {
    weak var parentVC: UIViewController?
    
    private var viewModel: ConverterViewModel
    private let disposeBag = DisposeBag()
    
    lazy var addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
    lazy var editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTasks))
    lazy var startBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(convertImage))
    var toolbarItems: [UIBarButtonItem] {
        [
            addBtn,
            UIBarButtonItem(systemItem: .flexibleSpace),
            editBtn,
            UIBarButtonItem(systemItem: .flexibleSpace),
            startBtn
        ]
    }
    
    private lazy var tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(ImageTaskCellView.self, forCellReuseIdentifier: ImageTaskCellView.resusableIdentifier)
        tv.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tv.backgroundColor = .systemGroupedBackground
        return tv
    }()
    
    init(parentVC: UIViewController, viewModel: ConverterViewModel) {
        self.viewModel = viewModel
        self.parentVC = parentVC
        super.init(frame: .zero)
        initUI()
        initLayout()
        setBinding()
    }
    
    private func initUI() {
        backgroundColor = .systemBackground
    }
    
    private func initLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func setBinding() {
        viewModel.reloadTableviewRelay
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.reloadTable()
            }).disposed(by: disposeBag)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func addImage() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.selection = .ordered
        config.filter = .images
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        parentVC?.present(imagePicker, animated: true)
    }
    
    @objc func editTasks() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editBtn = UIBarButtonItem(barButtonSystemItem: tableView.isEditing ? .done : .edit, target: self, action: #selector(editTasks))
        parentVC?.toolbarItems = toolbarItems
    }
    
    @objc private func convertImage() {
        viewModel.convertImages()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - TableView Delegate
extension ConverterView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.imageTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTaskCellView.resusableIdentifier, for: indexPath) as! ImageTaskCellView
        cell.setData(task: viewModel.imageTasks[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.imageTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}


// MARK: - PHPickerViewControllerDelegate
extension ConverterView: PHPickerViewControllerDelegate {
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
                    self.reloadTable()
                }
            }
        }
    }
}
