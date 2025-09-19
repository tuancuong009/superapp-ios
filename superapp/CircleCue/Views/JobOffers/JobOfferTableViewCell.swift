//
//  JobOfferTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit

class JobOfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var postedByView: UIView!
    
    weak var delegate: AddJobOffseDelegate?
    private var item: Blog_Job?
    
    func setup(_ item: Blog_Job) {
        postedByView.isHidden = true
        titleLabel.text = item.title
        contentLabel.text = item.content
        dateLabel.text = item.date
    }
    
    func setupSearchEvent(_ item: Blog_Job) {
        self.item = item
        postedByView.isHidden = false
        titleLabel.text = item.title
        contentLabel.text = item.content
        dateLabel.text = item.date
        postedByUserLabel.text = item.username
        postedByView.isHidden = item.username.trimmed.isEmpty
    }
    
    func setupSearchJob(_ item: SearchJob) {
        postedByView.isHidden = true
        titleLabel.text = item.title
        contentLabel.text = item.content
        dateLabel.text = item.username
    }
    
    func setupSearchResume(_ item: SearchResume) {
        postedByView.isHidden = true
        titleLabel.text = item.resume_title
        contentLabel.text = item.resume_text
        dateLabel.text = item.username
    }
    
    @IBAction func didTapViewUserButton(_ sender: Any) {
        guard let item = item else {
            return
        }
        delegate?.viewUserProfile(id: item.u_id)
    }
}
