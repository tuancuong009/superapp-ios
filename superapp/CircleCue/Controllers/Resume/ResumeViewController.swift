//
//  ResumeViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import WebKit

protocol ResumeViewDelegate: AnyObject {
    func didUpdateResume()
}

class ResumeViewController: BaseViewController {

    @IBOutlet weak var resumeTitleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var noResumeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var resumeImageView: UIImageView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var holderLabel: UILabel!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioImageView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionView: UIView!
    
    var user: UserInfomation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noResumeLabel.text = "No Resume uploaded"
        resumeTitleLabel.text = nil
        setupUI()
        setupTextView()
    }
    
    override func addNote() {
        let controller = UpdateResumeViewController.instantiate()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func moreAction(_ sender: Any) {
        showOption()
    }
    
    @IBAction func watchVideoAction(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://youtu.be/U-HOpIzY9Y8")
    }
    
    @IBAction func didTapResumeImage(_ sender: Any) {
        self.showSimplePhotoViewer(for: resumeImageView, image: resumeImageView.image)
    }
}

extension ResumeViewController {
    
    private func setupUI() {
        noResumeLabel.isHidden = true
        introductionView.isHidden = true
        stackView.isHidden = !noResumeLabel.isHidden
        moreButton.isHidden = true
        bioTextView.text = ""
        if let user = user {
            self.resumeTitleLabel.text = user.resume_title
            self.introductionView.isHidden = true
            self.topBarMenuView.leftButtonType = 1
            self.topBarMenuView.showRightMenu = false
            self.moreButton.isHidden = true
            if user.resume != nil || user.resume_text != nil {
                if user.resume == nil {
                    stackBottomConstraint.priority = .defaultLow
                } else {
                    stackBottomConstraint.priority = .required
                }
                noResumeLabel.isHidden = true
                stackView.isHidden = !noResumeLabel.isHidden
                if let resume = user.resume {
                    bioImageView.isHidden = false
                    if resume.isImageURL {
                        webView.isHidden = true
                        resumeImageView.isHidden = false
                        resumeImageView.setImage(with: resume, placeholderImage: .photo)
                    } else {
                        webView.isHidden = false
                        resumeImageView.isHidden = true
                        loadWeb(resume)
                    }
                } else {
                    bioImageView.isHidden = true
                }
                
                if let resume_text = user.resume_text {
                    bioView.isHidden = false
                    bioTextView.text = resume_text
                    holderLabel.isHidden = bioTextView.hasText
                } else {
                    bioView.isHidden = true
                }
            } else {
                noResumeLabel.isHidden = false
                stackView.isHidden = !noResumeLabel.isHidden
            }
        } else {
            guard let user = AppSettings.shared.currentUser else { return }
            self.resumeTitleLabel.text = user.resume_title
            if user.resume != nil || user.resume_text != nil {
                if user.resume == nil {
                    stackBottomConstraint.priority = .defaultLow
                } else {
                    stackBottomConstraint.priority = .required
                }
                
                self.topBarMenuView.showRightMenu = false
                noResumeLabel.isHidden = true
                introductionView.isHidden = noResumeLabel.isHidden
                stackView.isHidden = !noResumeLabel.isHidden
                moreButton.isHidden = false
                if let resume = user.resume {
                    bioImageView.isHidden = false
                    if resume.isImageURL {
                        webView.isHidden = true
                        resumeImageView.isHidden = false
                        resumeImageView.setImage(with: resume, placeholderImage: .photo)
                    } else {
                        webView.isHidden = false
                        resumeImageView.isHidden = true
                        loadWeb(resume)
                    }
                } else {
                    bioImageView.isHidden = true
                }
                if let resume_text = user.resume_text {
                    bioView.isHidden = false
                    bioTextView.text = resume_text
                    holderLabel.isHidden = bioTextView.hasText
                } else {
                    bioView.isHidden = true
                }
            } else {
                self.topBarMenuView.showRightMenu = true
                self.topBarMenuView.rightButtonType = 1
                noResumeLabel.isHidden = false
                introductionView.isHidden = noResumeLabel.isHidden
                stackView.isHidden = !noResumeLabel.isHidden
            }
        }
    }
    
    private func setupTextView() {
        bioTextView.textContainerInset.left = 6
        bioTextView.textContainerInset.right = 6
        bioTextView.delegate = self
    }
    
    private func loadWeb(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func showOption() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.editResume()
        }
        let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
            self.shareResume()
            
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.showAlert(title: "Are you sure you want to delete?", message: nil, buttonTitles: ["No", "Yes"], highlightedButtonIndex: 1) { (index) in
                if index == 1 {
                    self.deleteResume()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func editResume() {
        let controller = UpdateResumeViewController.instantiate()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func shareResume() {
        guard let user = AppSettings.shared.currentUser else { return }
        let content = "\(user.resume_text ?? "") \(user.resume ?? "")"
        let activityVC = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func deleteResume() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.deleteResume(userId) {[weak self] (error) in
            guard let self = self else { return }
            if let err = error {
                return self.showErrorAlert(message: err)
            }
            
            self.showSuccessHUD(text: "Your resume has been deleted.", dismisAfter: 1)
            AppSettings.shared.currentUser?.resume_title = nil
            AppSettings.shared.currentUser?.resume = nil
            AppSettings.shared.currentUser?.resume_text = nil
            AppSettings.shared.currentUser?.resume_status = true
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
}

extension ResumeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        holderLabel.isHidden = textView.hasText
    }
}

extension ResumeViewController: ResumeViewDelegate {
    func didUpdateResume() {
        setupUI()
    }
}
