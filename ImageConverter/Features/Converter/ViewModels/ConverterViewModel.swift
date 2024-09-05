//
//  ConverterViewModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 30/8/2024.
//

import UIKit

class ConverterViewModel: NSObject {
    var imageTasks = [ImageTaskModel]()
    
    @objc func convertImages() {
        for imageTask in imageTasks {
            if let outputImage = imageTask.getOutputImage() {
                let ptr = UnsafeMutablePointer<Int>(&imageTask.index)
                UIImageWriteToSavedPhotosAlbum(outputImage, self, #selector(savedImage), ptr)
            }
        }
    }
    
    @objc func savedImage(_ image:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        guard error != nil else { return }
        
        if let ptr = context {
            let index = ptr.load(as: Int.self)
            imageTasks[index].status = .DONE
        }
    }
}
