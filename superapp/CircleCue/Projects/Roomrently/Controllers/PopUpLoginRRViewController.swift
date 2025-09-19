//
//  PopUpLoginViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 18/10/24.
//

import UIKit

class PopUpLoginRRViewController: UIViewController {
    var tapLogin: (() ->())?
    var tapSignUp: (() ->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doLogin(_ sender: Any) {
        self.dismiss(animated: true) {
            self.tapLogin?()
        }
    }
    @IBAction func doClose(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doSignUp(_ sender: Any) {
        self.dismiss(animated: true) {
            self.tapSignUp?()
        }
    }
}
