//
//  CircleFeedTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 08/12/2023.
//

import UIKit
protocol CircleFeedTableViewCellDelegate: AnyObject {
    func viewUserProfileAction(_ newFeed: NewFeed)
    func likeAction(_ newFeed: NewFeed)
    func viewComment(_ newFeed: NewFeed)
    func viewLikeAction(_ newFeed: NewFeed)
    func playVideo(_ newFeed: NewFeed)
    func viewPhoto(_ newFeed: NewFeed, imageView: UIImageView)
    func optionActionUser(_ newFeed: NewFeed, cell: CircleFeedTableViewCell)
    func messageUserProfile(_ newFeed: NewFeed)
    func viewUserProfileComment(_ newFeed: NewFeed)
    func readMoreFeed(_ indexpath: IndexPath, cell: CircleFeedTableViewCell)
}
class CircleFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var icAvatar: UIImageView!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var icLike: UIImageView!
    @IBOutlet weak var lblNumberLike: UILabel!
    @IBOutlet weak var lblNumberComment: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var viewContent: UIView!
    private var newFeed: NewFeed?
    weak var delegate: CircleFeedTableViewCellDelegate?
    @IBOutlet weak var btnReadMore: UIButton!
    var isExpanded: Bool = false {
            didSet {
                lblDesc.numberOfLines = isExpanded ? 0 : 2
                btnReadMore.setTitle(isExpanded ? "Read Less" : "Read More", for: .normal)
            }
        }
    
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        icAvatar.layer.cornerRadius = icAvatar.frame.size.width/2
        icAvatar.layer.masksToBounds = true
        icAvatar.layer.borderColor = UIColor.init(hex: "#25A8E0").cgColor
        icAvatar.layer.borderWidth = 3.0
        
        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.masksToBounds = true
        viewContent.layer.borderColor = UIColor.init(hex: "#DADADA").cgColor
        viewContent.layer.borderWidth = 1.0
        
        
        imgCell.layer.cornerRadius = 20
        imgCell.layer.masksToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setup(newFeed: NewFeed, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.newFeed = newFeed
        let mediaImage = newFeed.newFeedType == .image ? nil : UIImage(named: "btn_play")
        playButton.setImage(mediaImage, for: .normal)
        let comments = newFeed.comment_count
        lblNumberComment.text = "\(comments)"
      
        //let mediaImage = newFeed.newFeedType == .image ? nil : UIImage(named: "btn_play")
        //playButton.setImage(mediaImage, for: .normal)
        icAvatar.setImage(with: newFeed.userpic, placeholderImage: .avatar_small)
        lblName.text = newFeed.username
        if let date = self.formatDate(newFeed.date){
            lblCat.text = self.checkDate(inputDate: date)
        }
        else{
            lblCat.text = newFeed.date
        }
       
        lblDesc.text = newFeed.description
        let labelWidth = lblDesc.frame.width
                let font = lblDesc.font
        let maxHeight = font!.lineHeight * 2
                
                let boundingSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font
                ]
        let textHeight = newFeed.description.boundingRect(
                    with: boundingSize,
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: attributes,
                    context: nil
                ).height
                
                // Nếu chiều cao nội dung vượt quá 2 dòng, hiển thị nút Read More
        btnReadMore.isHidden = textHeight <= maxHeight
        let image = newFeed.user_like ? UIImage(named: "ic_heartsaved") : UIImage(named: "ic_likedhome")
        icLike.image = image
        
        lblNumberLike.text = "\(newFeed.like_count)"
       
        switch newFeed.newFeedType {
        case .image:
            if UIDevice.current.userInterfaceIdiom == .pad {
                imgCell.setImage(with: newFeed.pic, placeholderImage: .none)
            } else {
                imgCell.setImage(with: newFeed.pic, placeholderImage: .photoFeed)
            }
        case .video:
            imgCell.image = nil
            if let url = URL(string: newFeed.pic) {
                VideoThumbnail.shared.getThumbnailImageFromVideoUrl(url: url) { (image) in
                    DispatchQueue.main.async {
                        if let image = image {
                            self.imgCell.image = image
                        }
                    }
                }
            }
        }
        
       
    }
    func isTextExceedingTwoLines(label: UILabel) -> Bool {
        guard let labelText = label.text, !labelText.isEmpty else {
            return false
        }
        
        // Chiều rộng của UILabel
        let labelWidth = label.frame.width
        
        // Tính chiều cao của 2 dòng
        let maxLines: CGFloat = 2
        let maxHeight = label.font.lineHeight * maxLines
        
        // Tính chiều cao cần thiết để hiển thị toàn bộ nội dung
        let boundingSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: label.font as Any
        ]
        let textHeight = labelText.boundingRect(
            with: boundingSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        ).height
        
        // So sánh chiều cao tính được với chiều cao tối đa (2 dòng)
        return textHeight > maxHeight
    }
    
    private func formatDate(_ dateStr: String)-> Date?{
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy"
        return format.date(from: dateStr)
    }
    
    func checkDate(inputDate: Date) -> String {
        let calendar = Calendar.current
        
        // Lấy các thành phần của ngày hiện tại
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        
        // Lấy ngày bắt đầu của ngày truyền vào
        let inputDay = calendar.startOfDay(for: inputDate)
        
        if inputDay == today {
            return "Today"
        } else if inputDay == yesterday {
            return "Yesterday"
        } else {
            return self.formatDateTimeA(inputDate)
        }
    }
    
    
    private func formatDateTimeA(_ dateStr: Date)-> String{
        let format = DateFormatter()
        format.dateFormat = "MMM dd yyyy"
        return format.string(from: dateStr)
    }
    
    @IBAction func viewUserProfileAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.viewUserProfileAction(newFeed)
    }
    

    @IBAction func likeAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.likeAction(newFeed)
    }
    
    @IBAction func commentAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.viewComment(newFeed)
    }
    
    @IBAction func viewLikeAction(_ sender: Any) {
        guard let newFeed = newFeed, newFeed.like_count > 0 else { return }
        delegate?.viewLikeAction(newFeed)
    }
    
    @IBAction func playAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        switch newFeed.newFeedType {
        case .image:
            delegate?.viewPhoto(newFeed, imageView: self.imgCell)
        case .video:
            delegate?.playVideo(newFeed)
        }
    }
    @IBAction func optionAction(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.optionActionUser(newFeed, cell: self)
    }
    @IBAction func doMessageUser(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.messageUserProfile(newFeed)
    }
    @IBAction func clickProfileComment(_ sender: Any) {
        guard let newFeed = newFeed else { return }
        delegate?.viewUserProfileComment(newFeed)
    }
    @IBAction func doReadMore(_ sender: Any) {
        isExpanded.toggle()
//        
//        lblDesc.numberOfLines = 0
//        btnReadMore.isHidden = true
        self.delegate?.readMoreFeed(indexPath!, cell: self)
        
    }
}
