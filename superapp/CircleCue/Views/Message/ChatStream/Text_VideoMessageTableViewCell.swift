//
//  VideoMessageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import AVFoundation
import AVKit

class Text_VideoMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var friendContainerView: UIView!
    @IBOutlet weak var myContainerView: UIView!

    @IBOutlet weak var friendPlayerView: PlayerView!
    @IBOutlet weak var myPlayerView: PlayerView!
    
    @IBOutlet weak var friendOverlayView: UIView!
    @IBOutlet weak var myOverlayView: UIView!
    
    @IBOutlet weak var friendPlayButton: UIButton!
    @IBOutlet weak var myPlayVideoButton: UIButton!
    
    @IBOutlet weak var friendTextLabel: ChatMessageLabel!
    @IBOutlet weak var myTextLabel: ChatMessageLabel!
    
    @IBOutlet weak var myMessageTimeLabel: UILabel!
    @IBOutlet weak var friendMessageTimeLabel: UILabel!
    
    var message: Message?
    weak var delegate: MessageStreamViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myLongPress = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(longTapAction(_:)))
        myLongPress.minimumPressDuration = 0.3
        myContainerView.addGestureRecognizer(myLongPress)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        friendView.isHidden = true
        myView.isHidden = true
        message = nil
    }
    
    func setup(message: Message) {
        self.message = message
        myMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        friendMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        switch message.sender {
        case .me:
            myTextLabel.text = message.message
            friendView.isHidden = true
            myView.isHidden = false
            if let player = message.player {
                myPlayerView.playerLayer.player = player
            } else if let url = URL(string: message.mediaUrl) {
                let avPlayer = AVPlayer(url: url)
                myPlayerView.playerLayer.player = avPlayer
                if message.player == nil {
                    delegate?.didLoadPlayer(message, avPlayer: avPlayer)
                }
            }
        case .friend:
            friendTextLabel.text = message.message
            friendView.isHidden = false
            myView.isHidden = true
            if let player = message.player {
                friendPlayerView.playerLayer.player = player
            } else if let url = URL(string: message.mediaUrl) {
                let avPlayer = AVPlayer(url: url)
                friendPlayerView.playerLayer.player = avPlayer
                if message.player == nil {
                    delegate?.didLoadPlayer(message, avPlayer: avPlayer)
                }
            }
        }
    }
    
    @IBAction func playVideoAction(_ sender: UIButton) {
        guard let message = message else { return }
        if message.sender == .me {
            myPlayerView.player?.pause()
        } else {
            friendPlayerView.player?.pause()
        }
        self.delegate?.showFullScreen(message)
    }
    
    @objc func longTapAction(_ sender: UILongPressGestureRecognizer) {
        guard let message = message else { return }
        delegate?.showOption(message)
    }
}
