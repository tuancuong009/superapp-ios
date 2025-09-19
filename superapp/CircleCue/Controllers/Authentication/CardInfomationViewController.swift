//
//  CardInfomationViewController.swift
//  CircleCue
//
//  Created by Paul Ho on 19/01/2022.
//

import UIKit
import Alamofire

protocol CardInfomationDelegate: AnyObject {
    func didCreateSubscribe(status: Bool, uid: String)
}

class CardInfomationViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var nameOnCardTextField: UITextField!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var monthView: UIView!
    
    var uid: String?
    var plan: Int?
    weak var delegate: CardInfomationDelegate?
    
    private var monthDropDown = DropDown()
    private var yearDropDown = DropDown()
    
    private var monthDataSource: [Int] = []
    private var yearDataSource: [Int] = []
    
    private var month: Int? {
        didSet {
            monthTextField.text = month?.string
        }
    }
    
    private var year: Int? {
        didSet {
            yearTextField.text = year?.string
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        } completion: {_ in
            self.cardNumberTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func didTapMonthButton(_ sender: Any) {
        view.endEditing(true)
        monthDropDown.show()
    }
    
    @IBAction func didTapYearButton(_ sender: Any) {
        view.endEditing(true)
        yearDropDown.show()
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.closeView {
            self.delegate?.didCreateSubscribe(status: false, uid: self.uid!)
        }
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        self.view.endEditing(true)
        guard let uid = uid else {
            self.showErrorAlert(message: "No user found.")
            return
        }
        
        guard let plan = plan else {
            self.showErrorAlert(message: "No subscribe plan found.")
            return
        }

        guard let cardNumber = cardNumberTextField.trimmedText, !cardNumber.isEmpty,
              let month = month,
              let year = year,
              let cvv = cvvTextField.trimmedText, !cvv.isEmpty,
              let name = nameOnCardTextField.trimmedText, !name.isEmpty
        else {
            self.showErrorAlert(message: "Please fill all required fields.")
            return
        }
        let para: Parameters = ["card_number": cardNumber,
                                "expiry_date": "\(month)/\(year)",
                                "cvc": cvv,
                                "name_on_card": name,
                                "plan": plan,
                                "uid": uid]
        print(para)
        
        self.createSubscribe(para: para, uid: uid)
    }
}

extension CardInfomationViewController {
    
    private func setupUI() {
        for month in 1...12 {
            monthDataSource.append(month)
        }
        let currentYear = Calendar.current.component(.year, from: Date())
        for year in currentYear...currentYear+50 {
            yearDataSource.append(year)
        }
        
        containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 + containerView.frame.height/2)
        self.view.backgroundColor = .clear
    }
    
    private func setupDropdown() {
        monthDropDown.anchorView = monthView
        monthDropDown.dataSource = monthDataSource.map({ $0.string })
        monthDropDown.bottomOffset = CGPoint(x: 0, y: monthView.frame.height + 2)
        monthDropDown.direction = .bottom
        monthDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        monthDropDown.cellHeight = 40
        monthDropDown.animationduration = 0.2
        monthDropDown.backgroundColor = UIColor.white
        monthDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        monthDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        monthDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.month = self.monthDataSource[index]
        }
        
        yearDropDown.anchorView = yearView
        yearDropDown.dataSource = yearDataSource.map({ $0.string })
        yearDropDown.bottomOffset = CGPoint(x: 0, y: yearView.frame.height + 2)
        yearDropDown.direction = .bottom
        yearDropDown.textFont = UIFont.myriadProRegular(ofSize: 16)
        yearDropDown.cellHeight = 40
        yearDropDown.animationduration = 0.2
        yearDropDown.backgroundColor = UIColor.white
        yearDropDown.selectionBackgroundColor = UIColor.yellow.withAlphaComponent(0.3)
        yearDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.3)
        yearDropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.year = self.yearDataSource[index]
        }
    }
    
    private func closeView(completion: (() -> Void)? = nil) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.curveLinear, .allowUserInteraction]) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 + self.containerView.frame.height / 2)
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
}

extension CardInfomationViewController {
    
    private func createSubscribe(para: Parameters, uid: String) {
        self.showSimpleHUD(fromView: self.view)
        ManageAPI.shared.createSubscribe(para: para) {[weak self] result, error in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if result {
                    self.closeView {
                        self.delegate?.didCreateSubscribe(status: true, uid: uid)
                    }
                } else {
                    self.showErrorAlert(message: error)
                }
            }
        }
    }
}
