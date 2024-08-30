//
//  ConverterViewModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Software Trainee, Digital Solutions) on 30/8/2024.
//

import Foundation

class ConverterViewModel {
    var tasks = [ImageModel]()
    
    init() {
        for i in 0...10 {
            tasks.append(ImageModel(filename: "\(i).webp", outputFormat: .PNG))
        }
    }
}
