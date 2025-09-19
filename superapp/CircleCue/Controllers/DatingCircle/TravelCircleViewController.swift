//
//  TravelCircleViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 23/07/2021.
//

import UIKit
import Alamofire

class TravelCircleViewController: BaseViewController {

    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    var type: MenuItem?
    private var selectionStatus: ButtonStatus = .unselection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        guard let status = ButtonStatus(rawValue: sender.tag) else { return }
        updateSelection(status)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        guard selectionStatus != .unselection else {
            return showErrorAlert(message: "Please select an option.")
        }
        updateTravelCircleStatus(selectionStatus)
    }
}

extension TravelCircleViewController {
    private func updateTravelCircleStatus(_ status: ButtonStatus) {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        let para: Parameters = ["id": userId, "status": status.value]
        showSimpleHUD()
        ManageAPI.shared.updateTravelCircleStatus(para) {[weak self] (error) in
            guard let self = self else { return }
            self.hideLoading()
            if let err = error {
                self.showErrorAlert(message: err)
                return
            }
            AppSettings.shared.currentUser?.travel_status = (status == .yes ? true : false)
            self.showAlert(title: "CircleCue", message: "Your request has been submitted.")
        }
    }
}

extension TravelCircleViewController {
    private func setup() {
        setupUI()
    }
    
    private func setupUI() {
        updateSelection(.unselection)
        guard let user = AppSettings.shared.currentUser, let travel_status = user.travel_status else { return }
        switch travel_status {
        case true:
            updateSelection(.yes)
        case false:
            updateSelection(.no)
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
}
