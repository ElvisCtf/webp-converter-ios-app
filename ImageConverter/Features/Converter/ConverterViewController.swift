//
//  ConverterViewController.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 27/8/2024.
//

import UIKit
import SnapKit

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
        print("A")
    }
    
    @objc func convertImage() {
        print("B")
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
        cell.setString(filename: viewModel.tasks[indexPath.row].filename)
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

