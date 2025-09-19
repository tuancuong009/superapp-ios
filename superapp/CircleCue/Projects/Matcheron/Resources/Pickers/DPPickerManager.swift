

import UIKit

public typealias DPPickerCompletion = (_ cancel: Bool) -> Void
public typealias DPPickerDateCompletion = (_ date: Date?, _ cancel: Bool) -> Void
public typealias DPPickerValueIndexCompletion = (_ value: String?, _ index: Int, _ cancel: Bool) -> Void

open class DPPickerManager: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static let shared = DPPickerManager()

    private typealias PickerCompletionBlock  = (_ cancel: Bool) -> Void

    private var alertView: UIAlertController?
    private var pickerValues: [String]?
    private var pickerCompletion: PickerCompletionBlock?
    
    @objc open var timeZone: TimeZone? = TimeZone(identifier: "EN")
    
    // MARK: - Show
    
    @objc open func showPicker(title: String?, _ sender: Any?, selected: Date?, completion:DPPickerDateCompletion?) {
        let currentDate = Date()
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        var components = DateComponents()
        
        components.year = -110
        let minDate = gregorian?.date(byAdding: components, to: currentDate, options: NSCalendar.Options(rawValue: 0))
        self.showPicker(title: title, sender, selected: selected, min: minDate, max: currentDate, completion: completion)
    }
    
    @objc open func showPicker(title: String?, _ sender: Any?, selected: Date?, min: Date?, max: Date?, completion:DPPickerDateCompletion?) {
        self.showPicker(title: title, sender, picker: { (picker) in
            picker.date = selected ?? Date()
            picker.minimumDate = min
            picker.maximumDate = max
            picker.timeZone = self.timeZone
            picker.datePickerMode = .dateAndTime
        }, completion: completion)
    }
    
    
    @objc open func showPicker(title: String?, _ sender: Any?, picker:((_ picker: UIDatePicker) -> Void)?, completion:DPPickerDateCompletion?) {
        let datePicker = UIDatePicker()
        datePicker.timeZone = self.timeZone
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker?(datePicker)
        
        self.showPicker(title: title, sender, view: datePicker) { (cancel) in
            completion?(datePicker.date, cancel)
        }
    }
    
    @objc open func showPicker(title: String?,  _ sender: Any?, selected: String?, strings:[String], completion:DPPickerValueIndexCompletion?) {
        self.pickerValues = strings
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 20, height: picker.frame.size.height)
        if let value = selected {
            picker.reloadAllComponents()
            if strings.count > 0 {
                OperationQueue.current?.addOperation {
                    let index = strings.index(of: value) ?? 0
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }

        self.showPicker(title: title, sender, view: picker) { (cancel) in
            
            var index = -1
            var value: String? = nil
            
            if !cancel, strings.count > 0 {
                index = picker.selectedRow(inComponent: 0)
                if index >= 0 {
                    value = self.pickerValues?[index]
                }
            }
            
            completion?(value, index, cancel || index < 0)
        }
    }
    
    @objc open func showPicker(title: String?, _ sender: Any?, view: UIView, completion:DPPickerCompletion?) {
        
        var center: CGFloat?
        var buttonX: CGFloat = 0
        
        let image = UIImage(named: "ic_close_picker")?.withRenderingMode(.alwaysTemplate)
        
        // trick
        let alertView = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet);
        alertView.view.addSubview(view)
       
        if let btn = sender as? UIButton {
            alertView.popoverPresentationController?.sourceView = btn
            alertView.popoverPresentationController?.sourceRect = btn.bounds
        }
        else if let btn = sender as? UIView {
            alertView.popoverPresentationController?.sourceView = btn
            alertView.popoverPresentationController?.sourceRect = btn.bounds
        }
        else{
            alertView.popoverPresentationController?.sourceView = UIViewController.top?.view
            alertView.popoverPresentationController?.sourceRect = view.bounds
        }
       
        alertView.view.tintColor = .gray
        self.alertView = alertView

        // device orientation
        
        
        
        
        self.pickerCompletion = completion
        
       
        // ok button
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) in
            completion?(false)
        }
        alertView.addAction(ok)
        
        UIViewController.top?.present(alertView, animated: true, completion: nil)
        
    }
    
    // MARK: - Picker Delegates
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerValues?.count == 0 ? 0 : 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues?[row]
    }
    
    @objc internal func pickerClose(_ sender: UIButton) {
        alertView?.dismiss(animated: true, completion: {
            self.pickerCompletion?(true)
        })
    }
    
}

internal extension UIViewController {

    static var top: UIViewController? {
        get {
            return topViewController()
        }
    }

    static var root: UIViewController? {
        get {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
    }

    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        if let tabBarViewController = viewController as? UITabBarController {
            return topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
    
}
