//
//  ReligionPopUpViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 5/11/24.
//

import UIKit

class ReligionPopUpViewController: UIViewController {
    var tapYes: (() ->())?
    @IBOutlet weak var btnYes: UIButton!
    var religion = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        btnYes.setTitle("   YES, I'm \(religion)   ", for: .normal)
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
    @IBAction func doDissmiss(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func doYes(_ sender: Any) {
        self.dismiss(animated: true) {
            self.tapYes?()
        }
    }
}
