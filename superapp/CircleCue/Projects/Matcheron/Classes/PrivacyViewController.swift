//
//  PrivacyViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 15/10/24.
//

import UIKit

class PrivacyViewController: BaseViewController {

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

    @IBAction func doBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
