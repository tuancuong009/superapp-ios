//
//  MatchMarkingViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 14/1/25.
//

import UIKit
import LGSideMenuController
class MatchMarkingViewController: UIViewController {

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

    @IBAction func doSubcri(_ sender: Any) {
        let vc = SubcriViewController.init()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
}
