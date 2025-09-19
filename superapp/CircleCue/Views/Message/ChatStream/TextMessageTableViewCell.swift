//
//  TextMessageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit

class ChatMessageLabel: ActiveLabel, HelperProtocols {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.enabledTypes = [.url]
        self.URLColor = UIColor.link
        
        self.urlTapHandler = { url in
            print(url)
            self.openOutsideAppBrowser(url.absoluteString)
        }
    }
}

class TextMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var friendMessageLabel: ChatMessageLabel!
    @IBOutlet weak var myMessageLabel: ChatMessageLabel!
    
    @IBOutlet weak var friendContentView: UIView!
    @IBOutlet weak var myContentView: UIView!
    
    @IBOutlet weak var myMessageTimeLabel: UILabel!
    @IBOutlet weak var friendMessageTimeLabel: UILabel!
    @IBOutlet weak var deliveryImage: UIImageView!
    
    var message: Message?
    weak var delegate: MessageStreamViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let myLongPress = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(longTapAction(_:)))
        myLongPress.minimumPressDuration = 0.3
        myContentView.addGestureRecognizer(myLongPress)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        message = nil
        friendView.isHidden = true
        myView.isHidden = true
        friendMessageLabel.text = nil
        myMessageLabel.text = nil
    }
    
    func setup(message: Message) {
        self.message = message
        deliveryImage.setDeliveryImage(message.readstatus)
        myMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        friendMessageTimeLabel.text = message.created_at?.toDateString(.noteDashboard)
        switch message.sender {
        case .me:
            friendView.isHidden = true
            myView.isHidden = false
            myMessageLabel.text = message.message
            
            if message.messageType == .datingRequest {
                myContentView.backgroundColor = UIColor.init(hex: "22A9E1")
            } else {
                myContentView.backgroundColor = UIColor.init(hex: "ECE590")
            }
        case .friend:
            friendView.isHidden = false
            myView.isHidden = true
            friendMessageLabel.text = message.message
        }
    }
    
    func setupCircularChat(message: CircularMessage) {
        deliveryImage.image = nil
        friendView.isHidden = true
        myView.isHidden = false
        myMessageLabel.text = message.msg
    }
    
    @objc func longTapAction(_ sender: UILongPressGestureRecognizer) {
        guard let message = message else { return }
        delegate?.showOption(message)
    }
}
