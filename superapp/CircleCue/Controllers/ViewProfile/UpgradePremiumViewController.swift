//
//  UpgradePremiumViewController.swift
//  CircleCue
//
//  Created by Paul Ho on 19/01/2022.
//

import UIKit
import Alamofire
import SwiftUI

class UpgradePremiumViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var personalPremiumView: UIView!
    @IBOutlet weak var businessPremiumView: UIView!
    
    @IBOutlet weak var personalPermonthButton: UIButton!
    @IBOutlet weak var personalPerYearButton: UIButton!
    
    @IBOutlet weak var businessPermonthButton: UIButton!
    @IBOutlet weak var businessPerYearButton: UIButton!
    
    @IBOutlet weak var paymentBackgroundImageView: UIImageView!
    
    @IBOutlet weak var memberShipView: UIView!
    @IBOutlet weak var memberShipNameLabel: UILabel!
    
    @IBOutlet weak var helpView: UIView!
    @IBOutlet weak var helpTextView: UITextView!
    
    var userInfomation: UserInfomation?
    weak var delegate: CardInfomationDelegate?
    
    private var userType: AccountType = .personal {
        didSet {
            memberShipView.backgroundColor = userType == .personal ? Constants.red_brown : UIColor.red
            memberShipNameLabel.text = "VIP MEMBER BENEFITS"
            helpView.backgroundColor = userType == .personal ? Constants.light_blue : Constants.violet
            paymentBackgroundImageView.image = userType == .personal ? #imageLiteral(resourceName: "bg_payment") : #imageLiteral(resourceName: "bg_payment2")
            personalPremiumView.isHidden = userType != .personal
            businessPremiumView.isHidden = userType != .business
            personalPricePerMonth = true
            businessPricePerMonth = true
        }
    }
    
    private let selectedIconImage = #imageLiteral(resourceName: "ic_selected_payment_16")
    private let unselectedIconImage = #imageLiteral(resourceName: "ic_unselected_payment_16")
    
    private var personalPricePerMonth: Bool = true {
        didSet {
            personalPermonthButton.setImage(personalPricePerMonth ? selectedIconImage : unselectedIconImage, for: .normal)
            personalPerYearButton.setImage(!personalPricePerMonth ? selectedIconImage : unselectedIconImage, for: .normal)
        }
    }
    
    private var businessPricePerMonth: Bool = true {
        didSet {
            businessPermonthButton.setImage(businessPricePerMonth ? selectedIconImage : unselectedIconImage, for: .normal)
            businessPerYearButton.setImage(!businessPricePerMonth ? selectedIconImage : unselectedIconImage, for: .normal)
        }
    }
    
    private var plan: Int {
        if userType == .business {
            return businessPricePerMonth ? 2 : 1
        } else {
            return personalPricePerMonth ? 4 : 3
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.userInfomation?.accountType = .business
        setupUI()
    }
    
    @IBAction func didSelectPersionalPrice(_ sender: UIButton) {
        personalPricePerMonth = sender.tag == 0 ? true : false
    }
    
    @IBAction func didSelectBusinessPrice(_ sender: UIButton) {
        businessPricePerMonth = sender.tag == 0 ? true : false
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapUpgradeButton(_ sender: Any) {
        let controller = CardInfomationViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overFullScreen
        controller.plan = self.plan
        controller.uid = userInfomation?.userId
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension UpgradePremiumViewController {
    
    private func setupUI() {
        helpTextView.textContainerInset = UIEdgeInsets.zero
        helpTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        guard let user = userInfomation else { return }
        userType = user.accountType
    }
}

extension UpgradePremiumViewController: CardInfomationDelegate {
    
    func didCreateSubscribe(status: Bool, uid: String) {
        guard status else { return }
        self.delegate?.didCreateSubscribe(status: status, uid: uid)
        AppSettings.shared.currentUser?.premium = status
        self.showAlert(title: "Success", message: "Your have successfully subscribed.", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
