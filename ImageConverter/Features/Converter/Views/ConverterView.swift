//
//  ConverterView.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 2/9/2024.
//

import UIKit
import SnapKit
import RxSwift

class ConverterView: UIView {
    private var viewModel: ConverterViewModel
    private let disposeBag = DisposeBag()
    
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
    
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
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
        cell.setData(viewModel: viewModel, index: indexPath.row)
        cell.onFormatChange = { row, imageFormat in
            self.viewModel.imageTasks[indexPath.row].outputFormat = imageFormat
        }
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
