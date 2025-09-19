//
//  BaseVC.swift
//  Matcheron
//
//  Created by QTS Coder on 3/10/24.
//

import UIKit
import LGSideMenuController
import RappleProgressHUD
class BaseVC: AllViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadAllFontLabel()
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
    func getSubviewsOfView<T: UIView>(view: UIView) -> [T] {
        var subviewArray = [T]()
        if view.subviews.count == 0 {
            return subviewArray
        }
        for subview in view.subviews {
            subviewArray += self.getSubviewsOfView(view: subview) as [T]
            if let subview = subview as? T {
                subviewArray.append(subview)
            }
        }
        return subviewArray
    }
    
    func loadAllFontLabel(){
        let allLabels: [UILabel] = self.getSubviewsOfView(view: self.view)
        let allButtons: [UIButton] = self.getSubviewsOfView(view: self.view)
        let allUITextFields: [UITextField] = self.getSubviewsOfView(view: self.view)
        for allLabel in allLabels {
            allLabel.font = UIFont(name: allLabel.font.fontName, size: allLabel.font.pointSize + 2)
        }
        
        for allButton in allButtons {
            allButton.titleLabel?.font = UIFont(name: allButton.titleLabel!.font.fontName, size: allButton.titleLabel!.font.pointSize + 2)
        }
        
        for allUITextField in allUITextFields {
            allUITextField.font = UIFont(name: allUITextField.font!.fontName, size: allUITextField.font!.pointSize + 2)
        }
    }
}
