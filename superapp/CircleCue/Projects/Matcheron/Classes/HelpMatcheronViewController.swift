//
//  HelpViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 7/10/24.
//

import UIKit
import LGSideMenuController
class HelpMatcheronViewController: BaseMatcheronViewController {
    var isHelp = false
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHelp{
            btnMenu.setImage(UIImage.init(named: "btnback"), for: .normal)
            lblNavi.text = "Terms"
        }
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

    @IBAction func doLeftMenu(_ sender: Any) {
        if isHelp{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.sideMenuController?.showLeftView()
        }
    }
}
