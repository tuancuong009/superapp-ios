//
//  PlayerView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        let playerLayer = layer as! AVPlayerLayer
        playerLayer.videoGravity = .resizeAspectFill
        return playerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}
