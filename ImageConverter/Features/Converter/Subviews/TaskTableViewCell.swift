//
//  TaskTableViewCell.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 29/8/2024.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {
    static let resusableIdentifier = "TaskTableViewCell"
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var leadingIV: UIImageView = {
        let image = UIImage(systemName: "doc")
        let iv =  UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var fileLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = ""
        return lbl
    }()
    
    lazy var toLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = "To"
        return lbl
    }()
    
    lazy var formatBtn: UIButton = {
        let btn = UIButton(primaryAction: nil)
        btn.configuration = .tinted()
        btn.changesSelectionAsPrimaryAction = true
        btn.showsMenuAsPrimaryAction = true
        let actionClosure = { (action: UIAction) in
            btn.setTitle(action.title, for: .normal)
        }
        btn.menu = UIMenu(
            options: .displayInline,
            children: [
                UIAction(title: "PNG", handler: actionClosure),
                UIAction(title: "JPG", handler: actionClosure)
            ]
        )
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    func initUI() {
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
    
    func setString(filename: String) {
        fileLbl.text = filename
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
