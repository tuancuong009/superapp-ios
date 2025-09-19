//
//  NoteTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteContentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setup(note: Notes) {
        noteTitleLabel.text = note.title
        noteContentLabel.text = note.description
        dateLabel.text = note.date.toDateString(.noteDashboard)
    }
    
    func setup(note: Note) {
        noteTitleLabel.text = note.title
        noteContentLabel.text = note.note
        dateLabel.text = note.time
    }
}
