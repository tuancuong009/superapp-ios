//
//  PlayerViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/18/21.
//

import UIKit
import Alamofire

protocol PlayerViewControllerDelegate: AnyObject {
    func playedToTheEnd()
    func updateFeed(_ newFeed: NewFeed?)
}

class PlayerViewController: BaseViewController {

    var player: BMPlayer?
    var videoNewFeed: NewFeed?
    weak var delegate: PlayerViewControllerDelegate?
    
    private var isPausing: Bool = false
    var isLoop = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPausing {
            player?.play()
            isPausing = false
            return
        }
        guard let feed = videoNewFeed, let url = URL(string: feed.pic) else { return }
        player?.setVideo(resource: BMPlayerResource.init(url: url))
        player?.alpha = 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
    }
    
    public func playPauseVideo(play: Bool) {
        if play {
            player?.play()
        } else {
            player?.pause()
        }
    }
    public func resetPlayer() {
        self.player?.seek(.zero, completion: {
            self.player?.play()
        })
    }

    private func setupPlayer() {
        BMPlayerConf.enableBrightnessGestures = false
        BMPlayerConf.enableVolumeGestures = false
        BMPlayerConf.topBarShowInCase = .always
        BMPlayerConf.animateDelayTimeInterval = 3
        BMPlayerConf.hideFullscreenButton = true
        BMPlayerConf.hideBackButtonButton = true
        BMPlayerConf.isEnablePanGesture = false
        
        player = BMPlayer()
        player?.delegate = self
        player?.backgroundColor = UIColor.black
        self.view.addSubview(player!)
        player?.snp.makeConstraints({ (maker) in
            maker.bottom.left.right.top.equalToSuperview()
        })
        
        player?.backBlock = { [weak self] (isFullScreen) in
            self?.dismiss(animated: true, completion: nil)
        }
                
        guard let feed = videoNewFeed, let url = URL(string: feed.pic) else { return }
        player?.updateInfoUI(newFeed: feed)
        player?.setVideo(resource: BMPlayerResource.init(url: url))
        player?.alpha = 0
    }
}

extension PlayerViewController: BMPlayerDelegate {
    
    func viewUserProfile() {
        guard let _ = AppSettings.shared.currentUser, let newFeed = videoNewFeed else {
            return
        }
        self.isPausing = true
        player?.pause()
        
        if newFeed.uid == AppSettings.shared.userLogin?.userId {
//            let controller = MyProfileViewController.instantiate()
//            controller.didDismisController = { [weak self] in
//                self?.player?.play()
//            }
//            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: newFeed.uid, username: newFeed.username, country: newFeed.country, pic: newFeed.pic)
            controller.didDismisController = { [weak self] in
                self?.player?.play()
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func didTapLikeAction() {
        guard let feed = videoNewFeed, let userId = AppSettings.shared.currentUser?.userId else { return }
        self.likeAction(photoId: feed.id, userId: userId, shouldLike: feed.user_like)
    }
    
    func viewFeedComment() {
        guard let feed = videoNewFeed else { return }
        player?.pause()
        showComments(newFeed: feed)
    }
    
    func viewFeedLiked() {
        guard let feed = videoNewFeed else { return }
        player?.pause()
        showLikes(photoId: feed.id)
    }
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        
        if state == .playedToTheEnd {
            self.delegate?.playedToTheEnd()
        }
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
    }
}

extension PlayerViewController {
    
    private func showLikes(photoId: String) {
        let controller = LikesViewController.instantiate()
        controller.photoId = photoId
        
        controller.didDismisController = { [weak self] in
            self?.player?.play()
        }
        
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    private func showComments(newFeed: NewFeed) {
        let controller = CommentViewController.instantiate()
        controller.newFeed = newFeed
        controller.delegate = self
        let navigation = BaseNavigationController(rootViewController: controller)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    private func likeAction(photoId: String, userId: String, shouldLike: Bool) {
        let para: Parameters = ["pid": photoId, "uid": userId]
        self.showSimpleHUD(fromView: self.view)
        ManageAPI.shared.likePhoto(shouldLike: !shouldLike, para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if error == nil {
                    if !shouldLike {
                        self.videoNewFeed?.like_count += 1
                    } else {
                        let newLike = (self.videoNewFeed?.like_count ?? 0) - 1
                        self.videoNewFeed?.like_count = max(newLike, 0)
                    }
                    self.videoNewFeed?.user_like.toggle()
                    self.player?.updateInfoUI(newFeed: self.videoNewFeed)
                    self.delegate?.updateFeed(self.videoNewFeed)
                    
                } else {
                    self.showErrorAlert(message: error?.msg)
                }
            }
        }
    }
}

extension PlayerViewController: CommentViewControllerDelegate {
    
    func viewProfile(_ comment: PhotoComment) {
    }
    
    func didLoadAllComment(_ newFeed: NewFeed, commentNumber: Int) {
        self.videoNewFeed?.comment_count = commentNumber
        player?.updateInfoUI(newFeed: self.videoNewFeed)
        self.delegate?.updateFeed(self.videoNewFeed)
    }
    
    func showCommentOption(_ comment: PhotoComment) {
    }
    
    func didDismisCommentViewController() {
        player?.play()
    }
}
