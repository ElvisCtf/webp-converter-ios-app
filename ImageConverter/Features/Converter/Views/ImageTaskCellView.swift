//
//  ImageTaskCellView.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 29/8/2024.
//

import UIKit
import SnapKit

class ImageTaskCellView: UITableViewCell {
    static let resusableIdentifier = "ImageTaskCellView"
    private var viewModel: ConverterViewModel? = nil
    private var index = 0
    var onFormatChange: ((Int, ImageFormat) -> ())?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let leadingIV: UIImageView = {
        let image = UIImage(systemName: "doc")
        let iv =  UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let fileLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = ""
        return lbl
    }()
    
    private let toLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = "To"
        return lbl
    }()
    
    private lazy var formatBtn: UIButton = {
        let btn = UIButton(primaryAction: nil)
        btn.configuration = .tinted()
        btn.changesSelectionAsPrimaryAction = true
        btn.showsMenuAsPrimaryAction = true
        let actionClosure = { (action: UIAction) in
            if let changeFormat = self.onFormatChange {
                changeFormat(self.index, ImageFormat(rawValue: action.title) ?? .PNG)
                self.viewModel?.updateTaskStatus(index: self.index, status: .READY)
            }
        }
        btn.menu = UIMenu(
            options: .displayInline,
            children: [
                UIAction(title: ImageFormat.PNG.rawValue, handler: actionClosure),
                UIAction(title: ImageFormat.JPG.rawValue, handler: actionClosure)
            ]
        )
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    private func initUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(leadingIV)
        containerView.addSubview(fileLbl)
        containerView.addSubview(toLbl)
        containerView.addSubview(formatBtn)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
        
        leadingIV.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        fileLbl.snp.makeConstraints {
            $0.left.equalTo(leadingIV.snp.right).offset(24)
            $0.centerY.equalTo(leadingIV.snp.centerY)
        }
        
        toLbl.snp.makeConstraints {
            $0.left.equalTo(fileLbl.snp.right).offset(16)
            $0.centerY.equalTo(leadingIV.snp.centerY)
        }
        
        formatBtn.snp.makeConstraints {
            $0.left.equalTo(toLbl.snp.right).offset(24)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(leadingIV.snp.centerY)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(viewModel: ConverterViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
        let task = viewModel.imageTasks[index]
        fileLbl.text = task.filename
        
        switch task.status {
        case .READY:
            leadingIV.image = UIImage(systemName: "doc")
            leadingIV.tintColor = .systemBlue
        case .DONE:
            leadingIV.image = UIImage(systemName: "checkmark.rectangle.portrait")
            leadingIV.tintColor = .systemGreen
        case .ERROR:
            leadingIV.image = UIImage(systemName: "xmark.rectangle.portrait")
            leadingIV.tintColor = .systemRed
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
