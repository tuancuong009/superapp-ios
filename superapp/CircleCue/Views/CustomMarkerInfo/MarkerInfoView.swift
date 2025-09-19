//
//  MarkerInfoView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit
import MapKit

protocol MarkerInfoViewDelegate: AnyObject {
    func closeInfoWindow()
    func showInfomation(_ user: NearestUser)
}

class MarkerInfoView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var delegate: MarkerInfoViewDelegate?
    var user: NearestUser?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("MarkerInfoView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configurationView(_ user: NearestUser) {
        self.user = user
        contentLabel.text = "\(user.name ?? "") (\(user.distance ?? "") away from you)"
    }
    
    @IBAction func showInfoAction(_ sender: Any) {
        guard let user = user else { return }
        delegate?.showInfomation(user)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.closeInfoWindow()
    }
}
