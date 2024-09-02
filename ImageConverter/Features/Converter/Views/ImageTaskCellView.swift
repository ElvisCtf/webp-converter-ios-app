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
    var row = 0
    var changeFormatCallBack: ((Int, ImageFormat) -> ())?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 8
        return view
    }()
    
    let leadingIV: UIImageView = {
        let image = UIImage(systemName: "doc")
        let iv =  UIImageView(image: image)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let fileLbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.text = ""
        return lbl
    }()
    
    let toLbl: UILabel = {
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
            if let changeFormat = self.changeFormatCallBack {
                changeFormat(self.row, ImageFormat(rawValue: action.title) ?? .PNG)
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
