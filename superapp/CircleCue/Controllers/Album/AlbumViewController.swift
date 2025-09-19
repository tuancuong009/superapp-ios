//
//  AlbumViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import DTPhotoViewerController
import AVFoundation
import AVKit

class AlbumViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addHintView: UIView!
    
    private var selectedYear: Int = Calendar.current.component(.year, from: Date()) {
        didSet {
            self.noPhotoLabel.text = "No Album uploaded for \(selectedYear) year"
        }
    }
    private var photos: [Gallery] = []
    private var filterPhotos: [Gallery] = []
    private var selectedImageIndex: Int = 0
    private var dropDown = DropDown()
    
    var basicInfo: UniversalUser?
    private var viewing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        addHintView.isHidden = true
        
        if let userId = basicInfo?.id {
            fetchPhoto(userId: userId)
            topBarMenuView.leftButtonType = 1
            topBarMenuView.showRightMenu = false
            viewing = true
        } else {
            guard let userId = AppSettings.shared.userLogin?.userId else { return }
            fetchPhoto(userId: userId)
        }
    }
    
    override func addNote() {
        let controller = AddPhotoAlbumViewController.instantiate()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func showYearAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.arrowImage.transform = CGAffineTransform(rotationAngle: .pi)
        }
        dropDown.show()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let controller = AddPhotoAlbumViewController.instantiate()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension AlbumViewController {
    
    private func fetchPhoto(userId: String, loading: Bool = true) {
        showSimpleHUD()
        ManageAPI.shared.fetchGallery(userId: userId) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            
            self.photos = results
            DispatchQueue.main.async {
                self.filterPhoto()
            }
        }
    }
}

extension AlbumViewController {
    
    private func setup() {
        setupUI()
        setupCollectionView()
        setupDropdown()
    }
    
    private func setupUI() {
        selectedYear = Calendar.current.component(.year, from: Date())
        self.yearLabel.text = "\(selectedYear)"
        noPhotoLabel.isHidden = true
        noPhotoLabel.text = "No Album uploaded for \(selectedYear) year."
        if let info = basicInfo {
            topBarMenuView.title = info.username
        } else {
            topBarMenuView.title = AppSettings.shared.currentUser?.username
        }
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCell(identifier: AlbumCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func filterPhoto() {
        if photos.isEmpty {
            self.filterPhotos = []
            self.yearLabel.text = "\(selectedYear)"
            self.noPhotoLabel.isHidden = false
            self.dropDown.dataSource = ["\(selectedYear)"]
            self.addHintView.isHidden = false
            self.noPhotoLabel.isHidden = true
            self.collectionView.isHidden = true
            return
        }
        
        let group = Dictionary(grouping: photos) { (element) -> Int in
            return element.year
        }
        let sortedKey = group.keys.sorted().reversed()
        var dataSource: [String] = []
        
        for key in sortedKey {
            dataSource.append("\(key)")
        }
        if dataSource.contains("\(Calendar.current.component(.year, from: Date()))") == false {
            dataSource.append("\(Calendar.current.component(.year, from: Date()))")
        }
        dropDown.dataSource = dataSource.sorted().reversed()
        
        self.filterPhotos = photos.filter({$0.year == selectedYear})
        self.filterPhotos = filterPhotos.sorted(by: {$0.timeInterval > $1.timeInterval})
        
        collectionView.isHidden = filterPhotos.isEmpty
        noPhotoLabel.isHidden = !collectionView.isHidden
        self.addHintView.isHidden = true
        self.yearLabel.text = "\(selectedYear)"
        
        collectionView.reloadData()
    }
    
    private func setupDropdown() {
        dropDown.anchorView = headerView
        dropDown.bottomOffset = CGPoint(x: 0, y: headerView.frame.height)
        dropDown.direction = .bottom
        dropDown.textFont = UIFont.myriadProRegular(ofSize: 18)
        dropDown.cellHeight = 44.0
        dropDown.animationduration = 0.2
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.selectedYear = item.int ?? self.selectedYear
            self.filterPhoto()
        }
        
        dropDown.dismisAction = {
            UIView.animate(withDuration: 0.5) {
                self.arrowImage.transform = .identity
            }
        }
    }
    
    private func showDeleteConfirm(photo: Gallery) {
        let alert = UIAlertController(title: "Are you sure you want to delete ?", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.delete(photo)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
        cell.setup(item: filterPhotos[indexPath.item])
        cell.delegate = self
        cell.deleteButton.isHidden = viewing
        cell.switchButton.isHidden = viewing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 61) / 3
        return CGSize(width: width, height: width * 2 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < filterPhotos.count, let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell else { return }
        selectedImageIndex = indexPath.row
        let viewController = CustomPhotoViewerController(referencedView: cell.photoImageView, image: cell.photoImageView.image)
        viewController.data = self.filterPhotos
        viewController.dataSource = self
        viewController.delegate = self
        viewController.customDelegate = self
        present(viewController, animated: true, completion: nil)
    }
}

extension AlbumViewController: PhotoAlbumDelegate {
    
    func changeShowOnFeed(photo: Gallery) {
        self.showSimpleHUD()
        ManageAPI.shared.changePhotoStatus(photoId: photo.id, status: !photo.showOnFeed) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if error == nil {
                if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
                    self.photos[index].showOnFeed.toggle()
                }
                if let index = self.filterPhotos.firstIndex(where: {$0.id == photo.id}) {
                    self.filterPhotos[index].showOnFeed.toggle()
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    }
                }
            } else {
                self.showErrorAlert(message: error)
            }
        }
    }

    func didAddNewPhoto() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        fetchPhoto(userId: userId, loading: false)
    }
    
    func deletePhoto(photo: Gallery) {
        showDeleteConfirm(photo: photo)
    }
    
    private func delete(_ photo: Gallery) {
        showSimpleHUD()
        ManageAPI.shared.deleteGalleryPhoto(userId: photo.uid, photoId: photo.id) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            
            DispatchQueue.main.async {
                if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
                    self.photos.remove(at: index)
                    self.filterPhoto()
                }
                
                if photo.albumType == .video {
                    VideoThumbnail.shared.removeThumbnailImage(for: photo.pic)
                }
            }
        }
    }
}

// MARK: - DTPhotoViewerControllerDataSource
extension AlbumViewController: DTPhotoViewerControllerDataSource {
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        if let cell = cell as? CustomPhotoCollectionViewCell {
            let item = filterPhotos[index]
            cell.cellDelegate = photoViewerController as? CustomPhotoViewerController
            cell.setup(item)
        }
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            return cell.photoImageView
        }
        return nil
    }
    
    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return filterPhotos.count
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let item = filterPhotos[index]
        if item.albumType == .video {
            imageView.image = PlaceHolderImage.video.image
            if let url = URL(string: item.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            imageView.image = image
                        } else {
                            imageView.image = PlaceHolderImage.video.image
                        }
                    }
                }
            }
        } else {
            imageView.setImage(with: item.pic, placeholderImage: .photo)
        }
    }
}

// MARK: - DTPhotoViewerControllerDelegate
extension AlbumViewController: DTPhotoViewerControllerDelegate {
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }
    
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        if let collectionView = collectionView {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
}

extension AlbumViewController: CustomPhotoViewerControllerDelegate {
    func didDismisViewerController() {
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        if let index = self.photos.firstIndex(where: {$0.id == photo.id}) {
            self.photos[index].likes = likes
        }
        
        if let index = filterPhotos.firstIndex(where: {$0.id == photo.id}) {
            filterPhotos[index].likes = likes
        }
    }
}
