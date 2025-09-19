//
//  HelperProtocols.swift
//  CircleCue
//
//  Created by QTS Coder on 28/02/2023.
//

import UIKit
import SafariServices
import MessageUI

protocol HelperProtocols {
}

extension HelperProtocols {
    
    var rootViewController: UIViewController? {
        UIWindow.key?.rootViewController
    }
    
    /// Switch to new RootViewController
    func switchRootViewController(_ viewcontroller: UIViewController, animation: Bool = true) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window {
            window.rootViewController?.dismiss(animated: false, completion: nil)
            window.rootViewController = viewcontroller
            if animation {
                UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    /// Open a URL outside of Application
    func openOutsideAppBrowser(_ urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // Generate random number of length characters
    func randomString(length: Int = 8) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    // Limit character input in Textview.
    func textLimit(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    func exportImage(from view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
