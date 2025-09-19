//
//  CustomPhotoViewerController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/11/20.
//

import UIKit
import DTPhotoViewerController
import Alamofire
import JGProgressHUD
import AVKit

protocol CustomPhotoViewerControllerDelegate: DTPhotoViewerControllerDelegate {
    func didDismisViewerController()
    func updateLikes(likes: [PhotoLike], for photo: Gallery)
}

protocol CustomPhotoCollectionViewDelegate: AnyObject {
    func showComments(photo: Gallery)
    func showLikes(photo: Gallery)
    func updateLikes(likes: [PhotoLike], for photo: Gallery)
    func showVideo(photo: Gallery)
    func showLoading()
    func hideLoading()
}

class CustomPhotoCollectionViewCell: DTPhotoCollectionViewCell {
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.font = UIFont.myriadProRegular(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var likeContentButton: UIButton = {
        let likeButton = UIButton()
        likeButton.titleLabel?.font = UIFont.myriadProRegular(ofSize: 13)
        likeButton.setTitleColor(Constants.yellow, for: .normal)
        likeButton.setTitleColor(.white, for: .highlighted)
        likeButton.addTarget(self, action: #selector(showLikeView), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "ic_unlike"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        return likeButton
    }()
    
    lazy var commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.setImage(UIImage(named: "ic_comment"), for: .normal)
        commentButton.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        return commentButton
    }()
    
    lazy var playVideoButton: UIButton = {
        let playVideoButton = UIButton()
        playVideoButton.setImage(UIImage(named: "btn_play"), for: .normal)
        playVideoButton.addTarget(self, action: #selector(showVideo), for: .touchUpInside)
        playVideoButton.translatesAutoresizingMaskIntoConstraints = false
        playVideoButton.isHidden = true
        return playVideoButton
    }()

    
    private var isLiked: Bool = false {
        didSet {
            let image = isLiked ? UIImage(named: "ic_like") : UIImage(named: "ic_unlike")
            likeButton.setImage(image, for: .normal)
        }
    }
    
    weak var cellDelegate: CustomPhotoCollectionViewDelegate?
    private var photo: Gallery?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(overlayView)
        addSubview(contentLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(commentButton)
        addSubview(likeContentButton)
        addSubview(playVideoButton)
        bringSubviewToFront(playVideoButton)
        
        NSLayoutConstraint.activate([stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                                     stackView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     stackView.heightAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([likeContentButton.leftAnchor.constraint(equalTo: self.stackView.rightAnchor, constant: 10),
                                     likeContentButton.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
                                     likeContentButton.heightAnchor.constraint(equalToConstant: 30)])
        
        NSLayoutConstraint.activate([contentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
                                     contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
                                     contentLabel.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -10)])
        
        NSLayoutConstraint.activate([overlayView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
                                     overlayView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                                     overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                                     overlayView.topAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -15)])
        
        NSLayoutConstraint.activate([playVideoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     playVideoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        
        imageView.backgroundColor = UIColor.white
    }
    
    func setup(_ item: Gallery) {
        self.photo = item
        playVideoButton.isHidden = item.albumType == .image
        contentLabel.createCustomAttribute(content: item.description + "\n",
                                           highlightContent: (item.date.toDate(.addNote)?.toAlbumDate() ?? ""),
                                           highlightFont: .myriadProRegular(ofSize: 14),
                                           highlightColor: Constants.yellow,
                                           contentFont: .myriadProSemiBold(ofSize: 16),
                                           contentColor: .white)
        if let likes = item.likes {
            self.setupLike(likes)
        } else {
            fetchPhotoLike(item)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photo = nil
        isLiked = false
        playVideoButton.isHidden = true
        likeContentButton.titleLabel?.text = nil
        likeContentButton.setTitle(nil, for: .normal)
        imageView.image = nil
    }
    
    private func fetchPhotoLike(_ photo: Gallery) {
        print("Fetching like for photo =", photo)
        ManageAPI.shared.fetchPhotoLikes(photo.id) {[weak self] (likes, error) in
            guard let self = self else { return }
            self.cellDelegate?.hideLoading()
            DispatchQueue.main.async {
                self.setupLike(likes)
                if error == nil {
                    self.photo?.likes = likes
                    self.cellDelegate?.updateLikes(likes: likes, for: photo)
                }
            }
        }
    }
    
    private func setupLike(_ likes: [PhotoLike]) {
        if likes.isEmpty {
            isLiked = false
            likeContentButton.titleLabel?.text = nil
            likeContentButton.setTitle(nil, for: .normal)
        } else {
            if let _ = likes.firstIndex(where: {$0.uid == AppSettings.shared.userLogin?.userId}) {
                isLiked = true
                var title = "You and \((likes.count - 1).toOtherLike)"
                if likes.count == 1 {
                    title = "You liked this"
                }
                
                likeContentButton.titleLabel?.text = title
                likeContentButton.setTitle(title, for: .normal)
            } else {
                isLiked = false
                let title = "\(likes.count) liked this"
                
                likeContentButton.titleLabel?.text = title
                likeContentButton.setTitle(title, for: .normal)
            }
        }
    }
    
    @objc private func likeAction() {
        guard let photo = photo, let userId = AppSettings.shared.userLogin?.userId else { return }
        let para: Parameters = ["pid": photo.id, "uid": userId]
        
        self.cellDelegate?.showLoading()
        ManageAPI.shared.likePhoto(shouldLike: !isLiked, para) {[weak self] (error) in
            guard let self = self else { return }
            if error == nil {
                self.fetchPhotoLike(photo)
            }
        }
    }
    
    @objc private func showLikeView() {
        guard let photo = self.photo else { return }
        cellDelegate?.showLikes(photo: photo)
    }
    
    @objc private func commentAction() {
        guard let photo = self.photo else { return }
        cellDelegate?.showComments(photo: photo)
    }
    
    @objc private func showVideo() {
        guard let photo = self.photo else { return }
        cellDelegate?.showVideo(photo: photo)
    }
}

class CustomPhotoViewerController: DTPhotoViewerController {
    
    var data: [Gallery] = []
    var isHiddenShare: Bool = false
    var feed: NewFeed?
    var customDelegate: CustomPhotoViewerControllerDelegate?
    
    var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    var closeButton: UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "ic_close_photo"), for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return closeButton
    }()
    
    var shareButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.setImage(#imageLiteral(resourceName: "ic_share"), for: .normal)
        shareButton.tintColor = UIColor.white
        shareButton.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return shareButton
    }()

    var shareFeedPhotoButton: UIButton = {
        let shareButton = UIButton(type: .system)
        shareButton.setImage(#imageLiteral(resourceName: "ic_share"), for: .normal)
        shareButton.tintColor = UIColor.white
        shareButton.addTarget(self, action: #selector(shareFeedPhotoAction(_:)), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        return shareButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !data.isEmpty {
            registerClassPhotoViewer(CustomPhotoCollectionViewCell.self)
        }
        
        view.addSubview(overlayView)
        view.addSubview(closeButton)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([closeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
                                     closeButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
                                     closeButton.widthAnchor.constraint(equalToConstant: 32),
                                     closeButton.heightAnchor.constraint(equalToConstant: 32)])
        
        NSLayoutConstraint.activate([shareButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
                                     shareButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
                                     shareButton.widthAnchor.constraint(equalToConstant: 32),
                                     shareButton.heightAnchor.constraint(equalToConstant: 32)])
        
        NSLayoutConstraint.activate([overlayView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                                     overlayView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
                                     overlayView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                                     overlayView.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10)])
        
        if feed != nil {
            view.addSubview(shareFeedPhotoButton)
            NSLayoutConstraint.activate([shareFeedPhotoButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
                                         shareFeedPhotoButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
                                         shareFeedPhotoButton.widthAnchor.constraint(equalToConstant: 32),
                                         shareFeedPhotoButton.heightAnchor.constraint(equalToConstant: 32)])
        }
 
        configureOverlayViews(hidden: true, animated: false)
        
        shareButton.isHidden = isHiddenShare
    }
    
    @objc
    func cancelButtonTapped(_ sender: UIButton) {
        hideInfoOverlayView(false)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func shareButtonTapped(_ sender: UIButton) {
        guard !data.isEmpty, currentPhotoIndex < data.count else { return }
        let item = data[currentPhotoIndex]
        let content = "\(item.title) - \(item.description) - \(item.date)"
        var activityItems: [Any] = [content]
        if let collectionView = self.scrollView as? UICollectionView, let cell = collectionView.cellForItem(at: IndexPath.init(item: currentPhotoIndex, section: 0)) as? CustomPhotoCollectionViewCell, let image = cell.imageView.image {
            activityItems.append(image)
        }
        
        if let url = URL(string: item.pic) {
            activityItems.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        }
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc
    func shareFeedPhotoAction(_ sender: UIButton) {
        guard let feed = feed else { return }
        let content = "\(feed.title) - \(feed.description) - \(feed.date)"
        var activityItems: [Any] = [content]
        if let url = URL(string: feed.pic) {
            activityItems.append(url)
        }
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        }
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    func hideInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: true, animated: animated)
    }

    func showInfoOverlayView(_ animated: Bool) {
        configureOverlayViews(hidden: false, animated: animated)
    }

    func configureOverlayViews(hidden: Bool, animated: Bool) {
        if hidden != closeButton.isHidden {
            let duration: TimeInterval = animated ? 0.2 : 0.0
            let alpha: CGFloat = hidden ? 0.0 : 1.0
            setOverlayElementsHidden(isHidden: false)
            UIView.animate(withDuration: duration, animations: {
                self.setOverlayElementsAlpha(alpha: alpha)
            }, completion: { _ in
                self.setOverlayElementsHidden(isHidden: hidden)
                }
            )
        }
    }

    func setOverlayElementsHidden(isHidden: Bool) {
        closeButton.isHidden = isHidden
        shareButton.isHidden = data.isEmpty ? true : isHidden
        overlayView.isHidden = isHidden
        if feed != nil {
            shareFeedPhotoButton.isHidden = isHidden
        }
    }

    func setOverlayElementsAlpha(alpha: CGFloat) {
        closeButton.alpha = alpha
        shareButton.alpha = alpha
        overlayView.alpha = alpha
        if feed != nil {
            shareFeedPhotoButton.alpha = alpha
        }
    }

    override func didReceiveTapGesture() {
        reverseInfoOverlayViewDisplayStatus()
    }
    
    @objc
    override func willZoomOnPhoto(at index: Int) {
        hideInfoOverlayView(false)
    }

    override func didEndZoomingOnPhoto(at index: Int, atScale scale: CGFloat) {
        showInfoOverlayView(true)
    }

    override func didEndPresentingAnimation() {
        showInfoOverlayView(true)
    }

    override func willBegin(panGestureRecognizer gestureRecognizer: UIPanGestureRecognizer) {
        hideInfoOverlayView(false)
    }

    override func didReceiveDoubleTapGesture() {
        hideInfoOverlayView(false)
    }

    // Hide & Show info layer view
    func reverseInfoOverlayViewDisplayStatus() {
        showInfoOverlayView(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        customDelegate?.didDismisViewerController()
    }
    
    private let simpleHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.font = UIFont.myriadProRegular(ofSize: 16)
        hud.detailTextLabel.font = UIFont.myriadProRegular(ofSize: 14)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        return hud
    }()
    
    func showSimpleHUD() {
        simpleHUD.show(in: self.view)
    }
    
    func hideLoading(delay: TimeInterval = 0) {
        simpleHUD.dismiss(afterDelay: delay)
    }
}

extension CustomPhotoViewerController: CustomPhotoCollectionViewDelegate {
    
    func showLoading() {
        showSimpleHUD()
    }
    
    func hideLoading() {
        self.hideLoading(delay: 0)
    }
    
    func showVideo(photo: Gallery) {
        var avPlayer: AVPlayer?
        
        if let player = photo.player {
            avPlayer = player
        } else if let url = URL(string: photo.pic) {
            avPlayer = AVPlayer(url: url)
        }
        
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        avPlayerController.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.present(avPlayerController, animated: true) {
                avPlayerController.player?.play()
            }
        }
    }
    
    func showLikes(photo: Gallery) {
        let controller = LikesViewController.instantiate()
        controller.likes = photo.likes ?? []
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func showComments(photo: Gallery) {
        let controller = CommentViewController.instantiate()
        controller.photo = photo
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func updateLikes(likes: [PhotoLike], for photo: Gallery) {
        if let index = data.firstIndex(where: {$0.id == photo.id}) {
            data[index].likes = likes
        }
        customDelegate?.updateLikes(likes: likes, for: photo)
    }
}
