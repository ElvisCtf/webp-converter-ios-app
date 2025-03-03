//
//  ConverterViewModel.swift
//  ImageConverter
//
//  Created by Elvis Cheng on 30/8/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class ConverterViewModel: NSObject {
    var reloadTableviewRelay = PublishRelay<Void>()
    var imageTasks = [ImageTaskModel]()
    
    func updateTaskStatus(index: Int, status: Status) {
        imageTasks[index].status = status
        reloadTableviewRelay.accept(())
    }
    
    func convertImages() {
        for (i, imageTask) in imageTasks.enumerated() {
            if let outputImage = imageTask.getOutputImage() {
                saveImageToAlbum(index: i, image: outputImage, albumName: Constants.albumName)
            }
        }
    }
    
    func saveImageToAlbum(index: Int, image: UIImage, albumName: String) {
        createAlbum(with: albumName) { album in
            if let album {
                self.saveImage(to: album, with: image, index: index)
            }
        }
    }
    
    private func createAlbum(with name: String, completion: @escaping (PHAssetCollection?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let firstObject = collection.firstObject {
            completion(firstObject)
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }) { success, error in
                if success, let placeholder = albumPlaceholder {
                    let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                    completion(fetchResult.firstObject)
                }
            }
        }
    }
    
    private func saveImage(to album: PHAssetCollection, with image: UIImage, index: Int) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            albumChangeRequest?.addAssets([assetPlaceholder as Any] as NSArray)
        }, completionHandler: { success, error in
            if success {
                self.imageTasks[index].status = .DONE
            } else if error != nil {
                self.imageTasks[index].status = .ERROR
            }
            self.reloadTableviewRelay.accept(())
        })
    }
        
}
