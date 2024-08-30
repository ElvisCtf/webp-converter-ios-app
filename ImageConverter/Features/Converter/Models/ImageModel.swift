//
//  ImageModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 29/8/2024.
//

import Foundation

enum ImageFormat: String {
    case PNG
    case JPG
}

class ImageModel {
    var filename: String
    var inputData: Data?
    var outputData: Data?
    var outputFormat: ImageFormat
    
    init(filename: String, inputData: Data? = nil, outputData: Data? = nil, outputFormat: ImageFormat) {
        self.filename = filename
        self.inputData = inputData
        self.outputData = outputData
        self.outputFormat = outputFormat
    }
}
