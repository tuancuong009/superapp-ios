//
//  ReportViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 14/10/24.
//

import UIKit

class ReportViewController: BaseMatcheronViewController {

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
    @IBAction func doReport(_ sender: Any) {
        self.showAlertMessageComback("Thanks for your report.") { success in
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
