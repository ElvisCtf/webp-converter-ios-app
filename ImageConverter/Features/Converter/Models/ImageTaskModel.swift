//
//  ImageTaskModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 29/8/2024.
//

import UIKit

enum ImageFormat: String {
    case PNG
    case JPG
}

enum Status: String {
    case READY
    case DONE
    case ERROR
}

final class ImageTaskModel {
    var index: Int
    var status: Status
    var filename: String
    var inputData: Data?
    var outputFormat: ImageFormat
    
    var outputData: Data? {
        guard let inputData, let inputImage = UIImage(data: inputData) else { return nil }
        return switch outputFormat {
        case .PNG:
            inputImage.pngData()
        case .JPG:
            inputImage.jpegData(compressionQuality: 1.0)
        }
    }
    
    init(index: Int, filename: String, inputData: Data? = nil, outputFormat: ImageFormat, status: Status = .READY) {
        self.index = index
        self.filename = filename
        self.inputData = inputData
        self.outputFormat = outputFormat
        self.status = status
    }
    
    func getOutputImage() -> UIImage? {
        if let outputData, let outputImage = UIImage(data: outputData) {
            return outputImage
        }
        return nil
    }
}
