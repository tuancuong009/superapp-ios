//
//  VideoThumbnailManger.swift
//  CircleCue
//
//  Created by QTS Coder on 1/7/21.
//

import UIKit
import AVFoundation

class VideoThumbnail {
    static let shared = VideoThumbnail()
    
    func removeThumbnailImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        deleteImage(forKey: url.lastPathComponent)
    }
    
    private func deleteImage(forKey key: String) {
        let fileManager = FileManager.default
        if let filePath = self.filePath(forKey: key), fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.removeItem(atPath: filePath.path)
                print("Delele file \(key)")
            } catch let error {
                print("Could not delete file: \(error)")
            }
        }
    }
    
    func preloadThumbnailVideo(_ videoURL: String) {
        guard let url = URL(string: videoURL) else {
            return
        }
        getThumbnailImageFromVideoUrl(url: url) { _ in }
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = retrieveImage(forKey: url.lastPathComponent) {
            completion(image)
            return
        }
        
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 0, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                self.store(image: thumbImage, forKey: url.lastPathComponent)
                completion(thumbImage)
            } catch {
                print(error.localizedDescription) //10
            }
        }
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    private func store(image: UIImage, forKey key: String) {
        guard let pngRepresentation = image.pngData(), let filePath = filePath(forKey: key) else { return }
        
        do  {
            try pngRepresentation.write(to: filePath, options: .atomic)
        } catch let err {
            print("Saving file resulted in error: ", err)
            return
        }
        
        print("Save file for key: \(key) successfull = ", filePath.absoluteString)
    }
    
    private func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
}
