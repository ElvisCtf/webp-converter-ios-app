//
//  ConverterViewModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 30/8/2024.
//

import UIKit

class ConverterViewModel {
    var images = [ImageModel]()
    
    func convertImages() {
        for image in images {
            guard let inputData = image.inputData, let inputImage = UIImage(data: inputData) else { continue }
            
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
