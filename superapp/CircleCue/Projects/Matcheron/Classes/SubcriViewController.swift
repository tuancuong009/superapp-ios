//
//  SubcriViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 14/1/25.
//

import UIKit

class SubcriViewController: UIViewController {

    @IBOutlet weak var txfMonth: UITextField!
    @IBOutlet weak var txfYear: UITextField!
    var indexMonth = -1
    var indexYear = -1
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

    @IBAction func doCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doMonth(_ sender: Any) {
        self.view.endEditing(true)
        let values = ["1", "2", "3", "4 ", "5", "6" ,"7", "8", "9", "10","11", "12"]
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Month"
        vc.indexSelect = indexMonth
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            indexMonth = vc.indexSelect
            self.txfMonth.text = vc.value
            
        }
        self.present(vc, animated: true)
    }
    @IBAction func doYear(_ sender: Any) {
        self.view.endEditing(true)
        let year = Calendar.current.component(.year, from: Date())
        var values: [String] = []
        for i in 0...5{
            values.append("\(year + i)")
        }
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Year"
        vc.indexSelect = indexYear
        vc.isRequiredSlect = true
        vc.tapDone = { [self] in
            indexYear = vc.indexSelect
            self.txfYear.text = vc.value
            
        }
        self.present(vc, animated: true)
    }
}
