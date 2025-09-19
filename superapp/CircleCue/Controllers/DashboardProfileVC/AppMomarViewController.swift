//
//  AppMomarViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 6/1/25.
//

import UIKit
import LGSideMenuController
class AppMomarViewController: BaseRRViewController {
    @IBOutlet weak var btnBacl: UIButton!
    var isMenu = false
    var links = ["https://apps.apple.com/us/app/circlecue-1-social-media-app/id1500649857" , "https://apps.apple.com/us/app/roomrently-rent-buy-sell/id6467609375", "https://apps.apple.com/us/app/matcheron-date-meet-match/id6695737762", "https://apps.apple.com/us/app/karkonnex-rent-buy-sell-cars/id6737510790"]
    override func viewDidLoad() {
        super.viewDidLoad()
        if isMenu{
            btnBacl.setImage(UIImage(named: "ic_menu"), for: .normal)
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
    @IBAction func doBack(_ sender: Any) {
        if isMenu{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            navigationController?.popViewController(animated: true)
        }
       
    }
    
    @IBAction func doMenuAction(_ sender: Any) {
        guard let btn = sender as? UIButton else{
            return
        }
        self.showOutsideAppWebContent(urlString: links[btn.tag])
    }
}
