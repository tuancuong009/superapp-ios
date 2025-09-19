//
//  ImagePicker.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import MobileCoreServices
import PhotosUI

enum MediaType: String {
    case image = "public.image"
    case video = "public.movie"
    
    var image: UIImage? {
        switch self {
        case .image:
            return nil
        case .video:
            return UIImage(named: "ic_video")
        }
    }
}

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
    func didSelect(videoURL: URL?)
    func mediaLocation(location: String?)
    func mediaDate(date: Date?)
    func didSelect(textFile: URL)
}

extension ImagePickerDelegate {
    func didSelect(videoURL: URL?) {}
    func mediaLocation(location: String?) {}
    func mediaDate(date: Date?) {}
    func didSelect(textFile: URL) {}
}

class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    private var cloudOnly: Bool = false
    private var showICloud: Bool?
    private var cameraTitle: String?
    private var libraryTitle: String?
    private var documentTypes: [String] = [kUTTypeJPEG as String, kUTTypePNG as String, kUTTypeImage as String]
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate, mediaTypes: [MediaType], allowsEditing: Bool, iCloud: Bool = false, cameraTitle: String? = nil, libraryTitle: String? = nil, documentTypes: [String]? = nil, cloudOnly: Bool = false) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        if let documentTypes = documentTypes {
            self.documentTypes = documentTypes
        }
        
        self.presentationController = presentationController
        self.delegate = delegate
        self.showICloud = iCloud
        self.cloudOnly = cloudOnly
        self.cameraTitle = cameraTitle
        self.libraryTitle = libraryTitle
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = allowsEditing
        self.pickerController.videoQuality = .typeMedium
        self.pickerController.videoMaximumDuration = 30
        self.pickerController.mediaTypes = mediaTypes.map({$0.rawValue})
    }
    
    private func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            self.presentationController?.present(self.pickerController, animated: true)
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                DispatchQueue.main.async {
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        self.presentationController?.present(self.pickerController, animated: true)
                        print("success")
                    }
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
        case .limited:
            self.presentationController?.present(self.pickerController, animated: true)
        @unknown default:
            break
        }
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.checkPermission()
        }
    }
    
    public func present(title: String? = nil, message: String? = nil, from sourceView: UIView) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        if !cloudOnly {
            if let action = self.action(for: .camera, title: cameraTitle != nil ? cameraTitle! : "Take Photo") {
                alertController.addAction(action)
            }
            
            if let action = self.action(for: .photoLibrary, title: libraryTitle != nil ? libraryTitle! : "Choose Photo") {
                alertController.addAction(action)
            }
        }
        
        let text = cloudOnly ? "Import File" : "Browse..."
        let iCloudAction = UIAlertAction(title: text, style: .default) { (action) in
            self.openCloud()
        }
        
        if showICloud == true {
            alertController.addAction(iCloudAction)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, mediaURL: URL?) {
        controller.dismiss(animated: true, completion: nil)
        if image != nil {
            self.delegate?.didSelect(image: image)
        }
        if mediaURL != nil {
            self.delegate?.didSelect(videoURL: mediaURL)
        }
    }
    
    private func openCloud() {
        let document = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        document.delegate = self
        document.allowsMultipleSelection = false
        document.shouldShowFileExtensions = true
        self.presentationController?.present(document, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil, mediaURL: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var selectImage: UIImage?
        var selectMediaURL: URL?
        if let mediaURL = info[.mediaURL] as? URL {
            selectMediaURL = mediaURL
        } else if let image = info[.editedImage] as? UIImage {
            selectImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectImage = image
        }
        
        print(info)

//        if let referenceURL = info[.referenceURL] as? URL {
//            let asset =  PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
//            if let location = asset.firstObject?.location {
//                self.fetchAddress(from: location)
//            } else {
//                self.delegate?.mediaLocation(location: nil)
//            }
//
//            self.delegate?.mediaDate(date: asset.firstObject?.creationDate)
//        } else if self.pickerController.sourceType == .camera {
//            if let currentLocation = AppSettings.shared.currentLocation {
//                self.fetchAddress(from: currentLocation)
//            } else {
//                self.delegate?.mediaLocation(location: nil)
//            }
//
//            self.delegate?.mediaDate(date: Date())
//        }
        
        self.pickerController(picker, didSelect: selectImage, mediaURL: selectMediaURL)
    }
    
    private func fetchAddress(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, _) in
            if let place = placemarks?.first {
                var address: String?
                if let sub = place.subAdministrativeArea, let admin = place.administrativeArea {
                    address = "\(sub), \(admin)"
                } else if let sub = place.subAdministrativeArea {
                    address = sub
                } else if let admin = place.administrativeArea {
                    address = admin
                }
                self.delegate?.mediaLocation(location: address)
            } else {
                self.delegate?.mediaLocation(location: nil)
            }
        }
    }
}

extension ImagePicker: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        if let url = urls.first {
            print(url.lastPathComponent, url.pathExtension)
            if url.pathExtension.lowercased().contains("txt") {
                delegate?.didSelect(textFile: url)
            } else if let data = try? Data(contentsOf: url) {
                if !cloudOnly {
                    delegate?.didSelect(image: UIImage(data: data))
                }
            }
            delegate?.mediaDate(date: nil)
            delegate?.mediaLocation(location: nil)
        }
    }
}
