//
//  MenuShopViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 6/8/24.
//

import UIKit

class MenuShopViewController: UIViewController {
    var tapMyProducts: (() ->())?
    var tapMyReceived: (() ->())?
    var tapAddProduct: (() ->())?
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

    @IBAction func doMyProducts(_ sender: Any) {
        dismiss(animated: true) {
            self.tapMyProducts?()
        }
        
    }
    @IBAction func doReceived(_ sender: Any) {
        dismiss(animated: true) {
            self.tapMyReceived?()
        }
        
    }
    @IBAction func doAddProduct(_ sender: Any) {
        dismiss(animated: true) {
            self.tapAddProduct?()
        }
       
    }
}
