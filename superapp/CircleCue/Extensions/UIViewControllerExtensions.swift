//
//  UIViewControllerExtensions.swift
//  DesignMaterial
//
//  Created by QTS Coder on 8/25/20.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Properties
public extension UIViewController {

    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }

}

// MARK: - Methods
public extension UIViewController {
    
    /// SwifterSwift: Instantiate UIViewController from storyboard
    ///
    /// - Parameters:
    ///   - storyboard: Name of the storyboard where the UIViewController is located
    ///   - bundle: Bundle in which storyboard is located
    ///   - identifier: UIViewController's storyboard identifier
    /// - Returns: Custom UIViewController instantiated from storyboard
    class func instantiate(from storyboard: String = "Main") -> Self {
        let viewControllerIdentifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? Self else {
            preconditionFailure("Unable to instantiate view controller with identifier \(viewControllerIdentifier) as type \(type(of: self))")
        }
        return viewController
    }

    /// SwifterSwift: Assign as listener to notification.
    ///
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener to notification.
    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// SwifterSwift: Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    /// SwifterSwift: Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult
    func showAlert(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProSemiBold(ofSize: 16), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 14), .foregroundColor: UIColor.black]
        
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttribute)
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }

        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                alertController.preferredAction = action
            }
        }
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
        return alertController
    }
    
    func showErrorAlert(title: String? = "Oops!", message: String?, errorColor: UIColor = .red){
        let newMessage = message?.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<BR>", with: "\n").trimmed
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProSemiBold(ofSize: 17), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 14), .foregroundColor: errorColor]
        
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttribute)
        let messageString = NSAttributedString(string: newMessage ?? "", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: title, message: newMessage, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /// SwifterSwift: Helper method to add a UIViewController as a childViewController.
    ///
    /// - Parameters:
    ///   - child: the view controller to add as a child
    ///   - containerView: the containerView for the child viewcontroller's root view.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }

    /// SwifterSwift: Helper method to remove a UIViewController from its parent.
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }

        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }

    #if os(iOS)
    /// SwifterSwift: Helper method to present a UIViewController as a popover.
    ///
    /// - Parameters:
    ///   - popoverContent: the view controller to add as a popover.
    ///   - sourcePoint: the point in which to anchor the popover.
    ///   - size: the size of the popover. Default uses the popover preferredContentSize.
    ///   - delegate: the popover's presentationController delegate. Default is nil.
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The block to execute after the presentation finishes. Default is nil.
    func presentPopover(_ popoverContent: UIViewController, sourcePoint: CGPoint, size: CGSize? = nil, delegate: UIPopoverPresentationControllerDelegate? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
        popoverContent.modalPresentationStyle = .popover

        if let size = size {
            popoverContent.preferredContentSize = size
        }

        if let popoverPresentationVC = popoverContent.popoverPresentationController {
            popoverPresentationVC.sourceView = view
            popoverPresentationVC.sourceRect = CGRect(origin: sourcePoint, size: .zero)
            popoverPresentationVC.delegate = delegate
        }

        present(popoverContent, animated: animated, completion: completion)
    }
    #endif

}

#endif
