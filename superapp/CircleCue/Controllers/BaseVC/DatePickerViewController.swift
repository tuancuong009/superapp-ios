//
//  DatePickerViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 21/04/2022.
//

import UIKit

protocol DatePickerViewDelegate: AnyObject {
    func didSelectDate(date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var selectedDate: Date?
    weak var delegate: DatePickerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        } completion: {_ in
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        closeView()
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        delegate?.didSelectDate(date: datePicker.date)
        closeView()
    }
}

extension DatePickerViewController {
    private func setupUI() {
        self.containerView.clipsToBounds = true
        self.containerView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        self.view.backgroundColor = .clear
        
        if let date = selectedDate {
            datePicker.setDate(date, animated: false)
        }
        datePicker.addTarget(self, action: #selector(self.updateSelectedDate), for: .valueChanged)
        selectedDateLabel.text = datePicker.date.toDateString(.addNote)
    }
    
    private func closeView(completion: (() -> Void)? = nil) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.curveLinear, .allowUserInteraction]) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    @objc private func updateSelectedDate() {
        selectedDateLabel.text = datePicker.date.toDateString(.addNote)
    }
}
