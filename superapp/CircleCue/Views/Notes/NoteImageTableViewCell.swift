//
//  NoteImageTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

class NoteImageTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteImageView: UIImageView!
    
    weak var delegate: NoteViewControllerDelegate?
    var note: Note?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        note = nil
        noteImageView.image = nil
    }
    
    func setup(note: Note) {
        self.note = note
        noteTitleLabel.text = note.title
        noteContentLabel.text = note.note
        dateLabel.text = note.time
        noteImageView.setImage(with: note.img ?? "", placeholderImage: .photo)
    }
    
    @IBAction func showImageAction(_ sender: Any) {
        guard let note = note else { return }
        delegate?.viewNoteImage(note, imageView: self.noteImageView)
    }
}
