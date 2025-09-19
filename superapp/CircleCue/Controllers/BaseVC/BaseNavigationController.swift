//
//  BaseNavigationController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        modalPresentationCapturesStatusBarAppearance = true
    }
}
