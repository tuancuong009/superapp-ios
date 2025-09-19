//
//  NotesViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit
import DTPhotoViewerController

class NotesViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var notes: [Note] = [] {
        didSet {
            self.noDataLabel.isHidden = !notes.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Notes/Reminders added yet"
        noDataLabel.isHidden = true
        setupTableView()
        fetchNote()
    }
    
    override func addNote() {
        let controller = NewNoteViewController.instantiate()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NotesViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: NoteTableViewCell.identifier)
        tableView.registerNibCell(identifier: NoteImageTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
    }
    
    private func fetchNote(loading: Bool = true) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        if loading {
            showSimpleHUD()
        }
        ManageAPI.shared.fetchNoteList(userId: userId) {[weak self] (notes, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                self.notes = notes
                self.tableView.reloadData()
            }
        }
    }
    
    private func showDeleteConfirm(_ note: Note) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?\nYou will not be able to recove it.", preferredStyle: .actionSheet)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.deleteNote(note)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteNote(_ note: Note) {
        guard let userId = AppSettings.shared.userLogin?.userId, let noteId = note.idd else { return }
        showSimpleHUD(text: "Deleting...")
        ManageAPI.shared.deleteNote(userId: userId, noteId: noteId) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showErrorAlert(message: err)
                    return
                }
                
                self.updateUI(noteId: noteId)
            }
        }
    }
    
    private func updateUI(noteId: String) {
        if let index = notes.firstIndex(where: {$0.idd == noteId}) {
            notes.remove(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
            tableView.endUpdates()
        }
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        if note.isNoteImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteImageTableViewCell.identifier, for: indexPath) as! NoteImageTableViewCell
            cell.setup(note: note)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as! NoteTableViewCell
        cell.setup(note: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete")
            self.showDeleteConfirm(notes[indexPath.row])
        }
    }
}

extension NotesViewController: NoteViewControllerDelegate {
    func didAddNewNote() {
        fetchNote(loading: false)
    }
    
    func viewNoteImage(_ note: Note, imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
}
