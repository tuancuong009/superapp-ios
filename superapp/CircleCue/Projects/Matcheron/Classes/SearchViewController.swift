//
//  SearchViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 27/9/24.
//

import UIKit
import LGSideMenuController
import Alamofire
class SearchViewController: BaseMatcheronViewController {
    @IBOutlet weak var btnSeekingFemale: UIButton!
    @IBOutlet weak var btnSeekingMale: UIButton!
   
    @IBOutlet weak var btnSeekingBoth: UIButton!
    
    @IBOutlet weak var cltGoals: UICollectionView!
    @IBOutlet weak var txfRegion: UITextField!
    @IBOutlet weak var btnParingEx: UIButton!
    @IBOutlet weak var btnParingOpen: UIButton!
    @IBOutlet weak var txfCountry: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var txfFromAge: UITextField!
    @IBOutlet weak var txfToAge: UITextField!
    @IBOutlet weak var txfFromWeight: UITextField!
    @IBOutlet weak var txfToWeight: UITextField!
    @IBOutlet weak var txfFromHeight: UITextField!
    @IBOutlet weak var txfTHeight: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txfCountryOfOrigin: UITextField!
    var isHome = false
    var countryId = "231"
    var arrCountries = [NSDictionary]()
    var arrStates = [NSDictionary]()
    var arrRegions = [NSDictionary]()
    var arrGoals = [NSDictionary]()
    var stateId = ""
    var RegionId = ""
    var seeking = ""
    var goal = ""
    var pairing = ""
    var indexRegion = 0
    var indexCountry = 0
    var indexState = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHome{
            btnMenu.setImage(UIImage.init(named: "btnback"), for: .normal)
            btnSubmit.setTitle("Search", for: .normal)
        }
        btnSeekingMale.isSelected = true
        btnSeekingFemale.isSelected = true
        if let user = APP_DELEGATE.user{
            let genderApi = user.object(forKey: "gender") as? String ?? ""
            if genderApi == "Male"{
                btnSeekingMale.isHidden = true
                btnSeekingFemale.isHidden = false
                
                seeking = "Female"
            }
            else{
                btnSeekingMale.isHidden = false
                btnSeekingFemale.isHidden = true
                
                seeking = "Male"
            }
        }
        cltGoals.register(UINib(nibName: "GoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoalCollectionViewCell")
    
        APIHelper.shared.getCountries { success, dict in
            self.hideBusy()
            if let dict = dict{
                self.arrCountries = dict
            }
        }
        
        APIHelper.shared.getReligions { success, dict in
            if let dict = dict{
                self.arrRegions = dict
            }
        }
        APIHelper.shared.getGoals { success, dict in
            if let dict = dict{
                self.arrGoals = dict
            }
            DispatchQueue.main.async {
                self.cltGoals.reloadData()
            }
            
        }
        
        APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
            self.hideBusy()
            self.arrStates.removeAll()
            if let dict = dict{
                self.arrStates = dict
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doBack(_ sender: Any) {
        if isHome{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.sideMenuController?.showLeftView(animated: true)
        }
        
    }
    @IBAction func doCountryOrgin(_ sender: Any) {
        let vc = OrginCountryViewController.init()
        vc.tapCountry = { [self] in
            txfCountryOfOrigin.text = vc.country
        }
        present(vc, animated: true)
    }
    
    @IBAction func doRegion(_ sender: Any) {
        var values = [String]()
        values.append("Select Religion")
        for arrRegion in arrRegions {
            values.append(arrRegion.object(forKey: "name") as? String ?? "")
        }
//        DPPickerManager.shared.showPicker(title: "Religion", sender, selected: txfRegion.text!, strings: values) { value, index, cancel in
//            if !cancel{
//                self.txfRegion.text = value
//                self.RegionId = self.arrRegions[index].object(forKey: "id") as? String ?? ""
//            }
//        }
        
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Religion"
        vc.indexSelect = indexRegion
        vc.tapDone = { [self] in
            if vc.indexSelect == 0{
                indexRegion = 0
                self.txfRegion.text = nil
                self.RegionId = ""
            }
            else{
                indexRegion = vc.indexSelect
                self.txfRegion.text = vc.value
                self.RegionId = self.arrRegions[indexRegion - 1].object(forKey: "id") as? String ?? ""
                
            }
            
            
        }
        self.present(vc, animated: true)
        
    }
    @IBAction func doContry(_ sender: Any) {
        var values = [String]()
        values.append("Select Country")
        for arrCountry in arrCountries {
            values.append(arrCountry.object(forKey: "country_name") as? String ?? "")
        }
        
        /*
        DPPickerManager.shared.showPicker(title: "Country", sender, selected: txfCountry.text!, strings: values) { value, index, cancel in
            if !cancel{
                if value !=  self.txfCountry.text!{
                    self.txfCountry.text = value
                    self.countryId = self.arrCountries[index].object(forKey: "id") as? String ?? ""
                    self.txfState.text = nil
                    self.stateId = ""
                    self.showBusy()
                    APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                        self.hideBusy()
                        self.arrStates.removeAll()
                        if let dict = dict{
                            self.arrStates = dict
                        }
                    }
                }
                
            }
        }
         */
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "Country"
        vc.indexSelect = indexCountry
        
        vc.tapDone = { [self] in
            if vc.indexSelect == 0{
                indexCountry = 0
                indexState = 0
                self.txfCountry.text = ""
                self.countryId = ""
                self.txfState.text = nil
                self.stateId = ""
            }
            else{
                indexCountry = vc.indexSelect
                self.txfCountry.text = vc.value
                self.countryId = self.arrCountries[indexCountry - 1].object(forKey: "id") as? String ?? ""
                self.txfState.text = nil
                self.stateId = ""
                self.showBusy()
                APIHelper.shared.getStates(countryId: self.countryId) { success, dict in
                    self.hideBusy()
                    self.arrStates.removeAll()
                    if let dict = dict{
                        self.arrStates = dict
                    }
                }
            }
        }
        self.present(vc, animated: true)
    }
    @IBAction func doState(_ sender: Any) {
        var values = [String]()
        values.append("Select State")
        for arrState in arrStates {
            values.append(arrState.object(forKey: "name") as? String ?? "")
        }

        
        let vc = PickerViewController()
        vc.arrDatas = values
        vc.titleNavi = "State"
        vc.indexSelect = indexState
        vc.tapDone = { [self] in
            if vc.indexSelect == 0{
                indexState = 0
                self.txfState.text = nil
                self.stateId = ""
            }
            else{
                indexState = vc.indexSelect
                self.txfState.text = vc.value
                self.stateId = self.arrStates[indexState - 1].object(forKey: "id") as? String ?? ""
                
            }
            
            
        }
        self.present(vc, animated: true)
        
        //        DPPickerManager.shared.showPicker(title: "State", sender, selected: txfState.text!, strings: values) { value, index, cancel in
        //            if !cancel{
        //                self.txfState.text = value
        //                self.stateId = self.arrStates[index].object(forKey: "id") as? String ?? ""
        //            }
        //        }
    }
    
    
    
    @IBAction func doParingOpen(_ sender: Any) {
        btnParingEx.isSelected = false
        btnParingOpen.isSelected = true
        pairing = "Open"
    }

    @IBAction func doParingEx(_ sender: Any) {
        btnParingEx.isSelected = true
        btnParingOpen.isSelected = false
        pairing = "Exclusive"
    }
    @IBAction func doSeekingMale(_ sender: Any) {
        btnSeekingMale.isSelected = true
        btnSeekingFemale.isSelected = false
        btnSeekingBoth.isSelected = false
        seeking = "Male"
    }
    @IBAction func doSeekingFemale(_ sender: Any) {
        btnSeekingMale.isSelected = false
        btnSeekingFemale.isSelected = true
        btnSeekingBoth.isSelected = false
        seeking = "Female"
    }
    @IBAction func doSeekingBoth(_ sender: Any) {
        btnSeekingMale.isSelected = false
        btnSeekingFemale.isSelected = false
        btnSeekingBoth.isSelected = true
        seeking = "Both"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doSubmit(_ sender: Any) {
        var param: Parameters = [:]
        param["uid"] = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        //if !txfCountryOfOrigin.text!.trimText().isEmpty{
            param["country_ori"] = txfCountryOfOrigin.text!
        //}
       
       // if !countryId.isEmpty{
            param["country"] = countryId
       // }
        //if !stateId.isEmpty{
            param["state"] = stateId
       // }
       // if !RegionId.isEmpty{
            param["religion"] = RegionId
        //}
       // if !seeking.isEmpty{
            param["seeking"] = seeking
       // }
        //if !goal.isEmpty{
            param["goal"] = goal
        //}
        //if !pairing.isEmpty{
            param["pairing"] = pairing
        //}
        //if !txfFromAge.text!.trimText().isEmpty{
            param["age1"] = txfFromAge.text!.trimText()
        //}
        //if !txfToAge.text!.trimText().isEmpty{
            param["age2"] = txfToAge.text!.trimText()
        //}
       // if !txfFromWeight.text!.trimText().isEmpty{
            param["weight1"] = txfFromWeight.text!.trimText()
       // }
        //if !txfToWeight.text!.trimText().isEmpty{
            param["weight2"] = txfToWeight.text!.trimText()
        //}
       // if !txfFromHeight.text!.trimText().isEmpty{
            param["height1"] = txfFromHeight.text!.trimText()
       // }
        //if !txfTHeight.text!.trimText().isEmpty{
            param["height2"] = txfTHeight.text!.trimText()
        //}
        print("Param-->", param)
        self.showBusy()
        APIHelper.shared.searchPefrance(param: param) { success, error in
            self.hideBusy()
            if success!
            {
                let vc = ResultSearchViewController.init()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                if let err = error{
                    self.showAlertMessage(message: err)
                }
            }
            
          
        }
        
    }
}
extension  SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // print("self.arrGoals.count--->",self.arrGoals.count)
        return self.arrGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltGoals.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
        let dict = self.arrGoals[indexPath.row]
        cell.lblName.text = dict.object(forKey: "name") as? String
        cell.lblName.font = UIFont(name: cell.lblName.font.fontName, size: 20)
        if let id = dict.object(forKey: "id") as? String, id == goal{
            cell.icSelect.image = UIImage(named: "radio2")
        }
        else{
            cell.icSelect.image = UIImage(named: "radio")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dict = self.arrGoals[indexPath.row]
        self.goal = dict.object(forKey: "id") as? String ?? ""
        cltGoals.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 1, height: 1)
    }
}
