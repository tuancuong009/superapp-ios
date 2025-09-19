//
//  AppSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 26/3/25.
//

import UIKit
import LGSideMenuController
enum NAVI_APP: Int{
    case apps = 0
    case hidden
    case messages
    var name: String{
        switch self {
        case .apps:
            return "APPS"
        
        case .hidden:
            return "Hidden"
        case .messages:
            return "Messages"
        }
    }
}
class AppSuperViewController: UIViewController {
    var navi: NAVI_APP = .apps
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNavi.text = navi.name
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

    @IBAction func doMenu(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
}
