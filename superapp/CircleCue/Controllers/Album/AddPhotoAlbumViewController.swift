//
//  AddPhotoAlbumViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import Alamofire
import AVKit
import Swifter
import Photos

protocol PhotoAlbumDelegate: AnyObject {
    func didAddNewPhoto()
    func deletePhoto(photo: Gallery)
    func changeShowOnFeed(photo: Gallery)
}

class MediaUploadModel {
    var type: MediaUploadType
    var data: Data
    
    init(type: MediaUploadType, data: Data) {
        self.type = type
        self.data = data
    }
}

class AddPhotoAlbumViewController: BaseViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photo1ImageView: UIImageView!
    @IBOutlet weak var photo2ImageView: UIImageView!
    @IBOutlet weak var photo3ImageView: UIImageView!
    @IBOutlet weak var addMorePhotoButton: UIButton!
    @IBOutlet weak var postOnFeedpageInformLabel: UILabel!
    @IBOutlet weak var keep_goneButton: UIButton!
    @IBOutlet weak var keepPostSwitch: UISwitch!
    @IBOutlet weak var postFeedSwitch: UISwitch!
    
    @IBOutlet weak var photo1DeleteButton: UIButton!
    @IBOutlet weak var photo2DeleteButton: UIButton!
    @IBOutlet weak var photo3DeleteButton: UIButton!
    
    weak var delegate: PhotoAlbumDelegate?
    private var imagePicker: ImagePicker?
    private var currentSelected: Int = 0
    
    private var mediaUpload1: MediaUploadModel?
    private var mediaUpload2: MediaUploadModel?
    private var mediaUpload3: MediaUploadModel?
    
    private var selectImage1: UIImage? = nil {
        didSet {
            photo1DeleteButton.isHidden = selectImage1 == nil
            photo1ImageView.image = selectImage1 ?? PlaceHolderImage.photo.image
            if selectImage1 != nil, photo2ImageView.isHidden == true {
                addMorePhotoButton.isHidden = false
            } else {
                addMorePhotoButton.isHidden = true
            }
        }
    }
    
    private var selectImage2: UIImage? = nil {
        didSet {
            photo2DeleteButton.isHidden = selectImage2 == nil
            photo2ImageView.image = selectImage2 ?? PlaceHolderImage.photo.image
            if selectImage2 != nil, photo3ImageView.isHidden == true {
                addMorePhotoButton.isHidden = false
            } else {
                addMorePhotoButton.isHidden = true
            }
        }
    }
    
    private var selectImage3: UIImage? = nil {
        didSet {
            photo3DeleteButton.isHidden = selectImage3 == nil
            photo3ImageView.image = selectImage3 ?? PlaceHolderImage.photo.image
        }
    }
    
    private var postOnFeedPage: Bool = false {
        didSet {
            postOnFeedpageInformLabel.text = postOnFeedPage ? "Post on Feed page & Album" : "Post on ALBUM Only"
        }
    }
    
    private var stayStatus: Bool = false {
        didSet {
            let text = stayStatus ? "KEEP" : "GONE"
            keep_goneButton.titleLabel?.text = text
            keep_goneButton.setTitle(text, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
//        let controller = DatePickerViewController.instantiate()
//        controller.selectedDate = selectDate
//        controller.modalTransitionStyle = .crossDissolve
//        controller.modalPresentationStyle = .overFullScreen
//        controller.delegate = self
//        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func selectImage1Action(_ sender: UITapGestureRecognizer) {
        currentSelected = 0
        imagePicker?.present(title: "Select Photo/Video", message: nil, from: photo1ImageView)
    }
    
    @IBAction func didTapRemovePhoto1Button(_ sender: Any) {
        selectImage1 = nil
        mediaUpload1 = nil
    }
    
    @IBAction func didTapRemovePhoto2Button(_ sender: Any) {
        selectImage2 = nil
        mediaUpload2 = nil
    }
    
    @IBAction func didTapRemovePhoto3Button(_ sender: Any) {
        selectImage3 = nil
        mediaUpload3 = nil
    }
    
    @IBAction func selectImage2Action(_ sender: UITapGestureRecognizer) {
        currentSelected = 1
        imagePicker?.present(title: "Select Photo/Video", message: nil, from: photo2ImageView)
    }
    
    @IBAction func selectImage3Action(_ sender: UITapGestureRecognizer) {
        currentSelected = 2
        imagePicker?.present(title: "Select Photo/Video", message: nil, from: photo3ImageView)
    }
    
    @IBAction func didTapAddMorePhotoButton(_ sender: Any) {
        if photo2ImageView.isHidden {
            photo2ImageView.isHidden = false
            addMorePhotoButton.isHidden = true
        } else if photo3ImageView.isHidden {
            photo3ImageView.isHidden = false
            addMorePhotoButton.isHidden = true
        }
    }
    
    @IBAction func searchLocationAction(_ sender: Any) {
        view.endEditing(true)
        let controller = SearchLocationViewController.instantiate()
        controller.didSelectLocation = { [weak self] location in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.locationTextField.text = location
            }
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        postOnFeedPage = sender.isOn
    }
    
    @IBAction func keep_goneSwitchAction(_ sender: UISwitch) {
        stayStatus = sender.isOn
    }
    
    @IBAction func submitAction(_ sender: Any) {
        view.endEditing(true)
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        
        var error = [String]()
        var para: Parameters = ["uid": userId, "showOnFeed": postOnFeedPage ? 1 : 0, "stay": stayStatus ? 0 : 1, "date": Date().toDateString(.addNote)]
        
        let mediaData = [mediaUpload1, mediaUpload2, mediaUpload3].compactMap({ $0 })
        if mediaData.isEmpty {
            error.append("Please add at least a Photo/Video")
        }
        if let location = locationTextField.text?.trimmed, !location.isEmpty {
            para.updateValue(location, forKey: "title")
        } 
        else{
            para.updateValue(" ", forKey: "title")
        }
//        else {
//            error.append(ErrorMessage.locationEmpty.rawValue)
//        }
        
        if captionTextView.text.trimmed.isEmpty {
            para.updateValue(" ", forKey: "description")
        } else {
            para.updateValue(captionTextView.text.trimmed, forKey: "description")
        }
        
        guard error.isEmpty else {
            let errorMessage = error.joined(separator: "\n")
            self.showErrorAlert(message: errorMessage)
            return
        }
        
        let group = DispatchGroup()
        
        showSimpleHUD(text: "Uploading...")
        for item in mediaData {
            self.uploadData(mediaUpload: item, para: para, group: group)
        }
        
        group.notify(queue: .main) {
            self.hideLoading()
            self.delegate?.didAddNewPhoto()
            self.showAlert(title: "Upload Successful!", message: "Your photos/videos have been uploaded.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { (_) in
                self.handleRedirectAfterPost()
            }
        }
    }
}

extension AddPhotoAlbumViewController {
    private func uploadData(mediaUpload: MediaUploadModel, para: Parameters, group: DispatchGroup) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        var fileName = "\(userId)\(randomString()).jpg"
        if mediaUpload.type == .video {
            fileName = "\(userId)\(randomString()).mp4"
        }
        
        group.enter()
        ManageAPI.shared.uploadFile(file: mediaUpload.data, fileName, mediaUpload.type) {[weak self] (path, error) in
            guard let self = self else { return }
            if let path = path {
                self.addNewPhoto(para, mediaPath: path, group: group)
                return
            }
            group.leave()
        }
    }
    
    private func addNewPhoto(_ para: Parameters, mediaPath: String, group: DispatchGroup) {
        var newPara = para
        newPara.updateValue(mediaPath, forKey: "ionicfile")
        ManageAPI.shared.addNewGalleryPhoto(para: newPara) { (error) in
            group.leave()
        }
    }
    
    private func handleRedirectAfterPost() {
        if postOnFeedPage {
            let feedVC = NewFeedsViewController.instantiate()
            feedVC.currentType = .all
            let homeVC = CircleFeedNewViewController.instantiate()
            let albumVC = AlbumViewController.instantiate()
            let viewControllers = [homeVC, albumVC, feedVC]
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddPhotoAlbumViewController {
    
    private func setup() {
        setupUI()
        setupTextField()
    }
    
    private func setupUI() {
        self.topBarMenuView.title = "Start a Post"
        imagePicker = ImagePicker(presentationController: self, delegate: self, mediaTypes: [.image, .video], allowsEditing: false, iCloud: true, cameraTitle: "Take Photo/Video", libraryTitle: "Choose Photo/Video")
        captionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 10, right: 5)
        captionTextView.delegate = self
        photo1ImageView.contentMode = .scaleAspectFill
        photo2ImageView.contentMode = .scaleAspectFill
        photo3ImageView.contentMode = .scaleAspectFill
        
        selectImage1 = nil
        selectImage2 = nil
        selectImage3 = nil
        
        photo2ImageView.isHidden = true
        photo2DeleteButton.isHidden = true
        photo3ImageView.isHidden = true
        photo3DeleteButton.isHidden = true
        addMorePhotoButton.isHidden = true
        
        keepPostSwitch.onTintColor = UIColor.systemGreen
        keepPostSwitch.tintColor = UIColor.red
        keepPostSwitch.thumbTintColor = UIColor.white
        keepPostSwitch.backgroundColor = UIColor.red
        keepPostSwitch.layer.cornerRadius = 16
        
        postFeedSwitch.onTintColor = UIColor.systemGreen
        postFeedSwitch.tintColor = UIColor.lightGray
        postFeedSwitch.thumbTintColor = UIColor.white
        postFeedSwitch.backgroundColor = UIColor.lightGray
        postFeedSwitch.layer.cornerRadius = 16
        keepPostSwitch.isOn = false
        postFeedSwitch.isOn = false
    }
    
    private func setupTextField() {
        locationTextField.delegate = self
        dateTextField.delegate = self
    }
}

extension AddPhotoAlbumViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
        switch currentSelected {
        case 0:
            self.selectImage1 = image
            if mediaUpload1 == nil {
                mediaUpload1 = MediaUploadModel(type: .image, data: data)
            } else {
                mediaUpload1?.data = data
                mediaUpload1?.type = .image
            }
            
        case 1:
            self.selectImage2 = image
            if mediaUpload2 == nil {
                mediaUpload2 = MediaUploadModel(type: .image, data: data)
            } else {
                mediaUpload2?.data = data
                mediaUpload2?.type = .image
            }
            
        case 2:
            self.selectImage3 = image
            if mediaUpload3 == nil {
                mediaUpload3 = MediaUploadModel(type: .image, data: data)
            } else {
                mediaUpload3?.data = data
                mediaUpload3?.type = .image
            }
        default:
            break
        }
    }
    
    func didSelect(videoURL: URL?) {
        print(videoURL as Any)
        guard let url = videoURL, let data = try? Data(contentsOf: url) else { return }
        print(url, data)
        switch currentSelected {
        case 0:
            self.selectImage1 = PlaceHolderImage.video.image
            if mediaUpload1 == nil {
                mediaUpload1 = MediaUploadModel(type: .video, data: data)
            } else {
                mediaUpload1?.data = data
                mediaUpload1?.type = .image
            }
        case 1:
            self.selectImage2 = PlaceHolderImage.video.image
            if mediaUpload2 == nil {
                mediaUpload2 = MediaUploadModel(type: .video, data: data)
            } else {
                mediaUpload2?.data = data
                mediaUpload2?.type = .image
            }
        case 2:
            self.selectImage3 = PlaceHolderImage.video.image
            if mediaUpload3 == nil {
                mediaUpload3 = MediaUploadModel(type: .video, data: data)
            } else {
                mediaUpload3?.data = data
                mediaUpload3?.type = .image
            }
        default:
            break
        }
    }
    
    func mediaLocation(location: String?) {
//        locationTextField.text = location
    }
    
    func mediaDate(date: Date?) {
//        self.selectDate = date
    }
}

extension AddPhotoAlbumViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}

extension AddPhotoAlbumViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddPhotoAlbumViewController: DatePickerViewDelegate {
    func didSelectDate(date: Date) {
//        selectDate = date
    }
}
