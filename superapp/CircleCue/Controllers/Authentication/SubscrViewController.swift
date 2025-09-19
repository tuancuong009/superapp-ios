//
//  SubscrViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 17/1/25.
//

import UIKit
protocol SubscrViewControllerDelegate: AnyObject{
    func didTapSelectPayment(month: Bool)
}
class SubscrViewController: UIViewController {
    weak var delegate:SubscrViewControllerDelegate?
   
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

    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
