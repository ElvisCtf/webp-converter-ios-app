//
//  ConverterViewModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 30/8/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ConverterViewModel: NSObject {
    var reloadTableviewRelay = PublishRelay<Void>()
    var imageTasks = [ImageTaskModel]()
    
    func updateTaskStatus(index: Int, status: Status) {
        imageTasks[index].status = status
        reloadTableviewRelay.accept(())
    }
    
    func convertImages() {
        for imageTask in imageTasks {
            if let outputImage = imageTask.getOutputImage() {
                let ptr = UnsafeMutablePointer<Int>(&imageTask.index)
                UIImageWriteToSavedPhotosAlbum(outputImage, self, #selector(savedImage), ptr)
            }
        }
    }
    
    @objc private func savedImage(_ image:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        guard error == nil else { return }
        
        if let ptr = context {
            let index = ptr.load(as: Int.self)
            imageTasks[index].status = .DONE
            reloadTableviewRelay.accept(())
        }
    }
}
