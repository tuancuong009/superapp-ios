//
//  DatingCircleViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit
import Alamofire

protocol DatingCircleDelegate: AnyObject {
    func showUserProfile()
}

enum ButtonStatus: Int {
    case yes = 0
    case no = 1
    case unselection = 3
    
    var value: String {
        switch self {
        case .yes:
            return "1"
        case .no:
            return "0"
        case .unselection:
            return ""
        }
    }
}

class DatingCircleViewController: BaseViewController {

    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var yesOptionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var yes18Yearold: UIButton!
    @IBOutlet weak var no18YearOld: UIButton!
    
    var type: MenuItem?
    private var selectionStatus: ButtonStatus = .unselection
    private var selectionStatus18YearOld: ButtonStatus = .unselection
    private var genderSelected: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        guard let status = ButtonStatus(rawValue: sender.tag) else { return }
        updateSelection(status)
    }
    
    @IBAction func chooseGenderAction(_ sender: UIButton) {
        if sender.tag == 0 {
            womanButton.setSelected(true)
            manButton.setSelected(false)
        } else {
            womanButton.setSelected(false)
            manButton.setSelected(true)
        }
        
        genderSelected = "\(sender.tag)"
        
    }
    
    @IBAction func submitAction(_ sender: Any) {
       
        guard selectionStatus != .unselection else {
            return showErrorAlert(message: "Please select an option.")
        }
        if selectionStatus == .yes && genderSelected == nil && AppSettings.shared.currentUser?.gender == nil {
            return showErrorAlert(message: "You must select your gender.")
        }
        updateUserGender()
        updateMyDatingStatus(selectionStatus)
    }
    @IBAction func do18YearOld(_ sender: UIButton) {
        guard let status = ButtonStatus(rawValue: sender.tag) else { return }
        updateSelectionDating18yearOld(status)
        if status == .yes{
            submitButton.isUserInteractionEnabled = true
            submitButton.alpha = 1.0
        }
        else{
            submitButton.isUserInteractionEnabled = false
            submitButton.alpha = 0.5
        }
    }
}

extension DatingCircleViewController {
    private func updateMyDatingStatus(_ status: ButtonStatus) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        let para: Parameters = ["id": userId, "status": status.value]
        showSimpleHUD()
        ManageAPI.shared.updateMyDatingStatus(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            AppSettings.shared.currentUser?.dating_status = (status == .yes ? true : false)
            self.showAlert(title: "CircleCue", message: "Your request has been submitted.")
            DispatchQueue.main.async {
                self.yesOptionLabel.isHidden = (status == .no)
            }
        }
    }
    
    private func updateUserGender() {
        guard let userId = AppSettings.shared.userLogin?.userId, let genderSelected = genderSelected, let gender = Gender(rawValue: genderSelected) else { return }
        if AppSettings.shared.currentUser?.gender != gender {
            ManageAPI.shared.updateUserGender(userId, gender: gender.rawValue) {[weak self] (error) in
                print("Update gender \(gender.rawValue) for \(userId) with error: ", error as Any)
                if error == nil {
                    AppSettings.shared.currentUser?.gender = gender
                    DispatchQueue.main.async {
                        self?.updateGenderUI()
                    }
                }
            }
        }
    }
}

extension DatingCircleViewController {
    private func setup() {
        yesOptionLabel.isHidden = true
        setupUI()
        updateGenderUI()
    }
    
    private func setupUI() {
        updateSelection(.unselection)
        guard let user = AppSettings.shared.currentUser else { return }
        switch user.dating_status {
        case true:
            updateSelection(.yes)
        case false:
            updateSelection(.no)
        }
        
        yesOptionLabel.isHidden = !user.dating_status
        updateSelectionDating18yearOld(.unselection)
        submitButton.isUserInteractionEnabled = false
        submitButton.alpha = 0.5
       
    }
    
    private func updateGenderUI() {
        guard let user = AppSettings.shared.currentUser else { return }
        switch user.gender {
        case .woman:
            womanButton.setSelected(true)
            manButton.setSelected(false)
            womanButton.isEnabled = false
            manButton.isEnabled = false
        case .man:
            womanButton.setSelected(false)
            manButton.setSelected(true)
            womanButton.isEnabled = false
            manButton.isEnabled = false
        case .none:
            womanButton.setSelected(false)
            manButton.setSelected(false)
        }
    }
    
    private func updateSelection(_ status: ButtonStatus) {
        selectionStatus = status
        switch status {
        case .yes:
            yesButton.backgroundColor = Constants.red_brown
            noButton.backgroundColor = .clear
        case .no:
            yesButton.backgroundColor = .clear
            noButton.backgroundColor = Constants.red_brown
        case .unselection:
            yesButton.backgroundColor = .clear
            noButton.backgroundColor = .clear
        }
    }
    
    private func updateSelectionDating18yearOld(_ status: ButtonStatus) {
        switch status {
        case .yes:
            yes18Yearold.backgroundColor = Constants.red_brown
            no18YearOld.backgroundColor = .clear
        case .no:
            yes18Yearold.backgroundColor = .clear
            no18YearOld.backgroundColor = Constants.red_brown
        case .unselection:
            yes18Yearold.backgroundColor = .clear
            no18YearOld.backgroundColor = .clear
        }
    }
}
