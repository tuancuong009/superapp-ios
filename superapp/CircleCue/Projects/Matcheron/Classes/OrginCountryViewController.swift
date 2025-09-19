//
//  OrginCountryViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 11/11/24.
//

import UIKit

class OrginCountryViewController: UIViewController {
    var tapCountry: (() ->())?
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var tblCountry: UITableView!
    var country = ""
    var arrCountryOrigins = [NSDictionary]()
    var arrCountrySearchOrigins = [NSDictionary]()
    var isSearch: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCountry.register(UINib(nibName: "OrginCountryTableViewCell", bundle: nil), forCellReuseIdentifier: "OrginCountryTableViewCell")
        readFileJson()
        // Do any additional setup after loading the view.
    }
    private func readFileJson(){
        if let path = Bundle.main.path(forResource: "country-by-abbreviation", ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                // let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResults = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary]{
                    print("jsonResults-->",jsonResults)
                    arrCountryOrigins = jsonResults
                    arrCountrySearchOrigins = jsonResults
                    self.tblCountry.reloadData()
                }
                
                
            } catch {
                print("Error---")
                // handle error
            }
        }
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
        dismiss(animated: true)
    }
}

extension OrginCountryViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? arrCountryOrigins.count + 1 :  arrCountryOrigins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearch{
            let cell =  tblCountry.dequeueReusableCell(withIdentifier: "OrginCountryTableViewCell") as! OrginCountryTableViewCell
            if indexPath.row == 0 {
                cell.lblName.text = "Select Country"
                return cell
            }
            else{
                let dict = arrCountryOrigins[indexPath.row - 1]
                cell.lblName.text = dict.object(forKey: "country") as? String
                return cell
            }
        }
        else{
            let cell =  tblCountry.dequeueReusableCell(withIdentifier: "OrginCountryTableViewCell") as! OrginCountryTableViewCell
            let dict = arrCountryOrigins[indexPath.row ]
            cell.lblName.text = dict.object(forKey: "country") as? String
            return cell
        }
       
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tblCountry.deselectRow(at: indexPath, animated: true)
        if isSearch{
            if indexPath.row == 0 {
                country = ""
                tapCountry?()
                dismiss(animated: true)
            }
            else{
                let dict = arrCountryOrigins[indexPath.row - 1]
                country = dict.object(forKey: "country") as? String ?? ""
                tapCountry?()
                dismiss(animated: true)
            }
        }
        else{
            let dict = arrCountryOrigins[indexPath.row]
            country = dict.object(forKey: "country") as? String ?? ""
            tapCountry?()
            dismiss(animated: true)
        }
        
      
    }
}


extension OrginCountryViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        arrCountryOrigins = arrCountrySearchOrigins
        tblCountry.reloadData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.isEmpty{
                arrCountryOrigins = arrCountrySearchOrigins
                tblCountry.reloadData()
            }
            else{
                arrCountryOrigins.removeAll()
                for item in arrCountrySearchOrigins{
                    let country = item.object(forKey: "country") as? String ?? ""
                    if country.lowercased().contains(updatedText.lowercased()){
                        arrCountryOrigins.append(item)
                    }
                }
                tblCountry.reloadData()
            }
            // do something with updatedText
        }
        return true
    }
}
