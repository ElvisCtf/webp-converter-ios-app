//
//  Constants.swift
//  ImageConverter
//
//  Created by Elvis Cheng (ESD - Senior Mobile App Developer, Digital Solutions) on 28/2/2025.
//

import Foundation

struct Constants {
    static let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "WebP Converter"
    static var albumName = appName.trimmingCharacters(in: .whitespaces)
}
