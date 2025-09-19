//
//  ContactUsViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 4/10/24.
//

import UIKit
import UIKit
import UniformTypeIdentifiers
import MobileCoreServices
import Alamofire
class ContactUsViewController: BaseMatcheronViewController {
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var btnDeleteFile: UIButton!
    @IBOutlet weak var btnChooseFile: UIButton!
    var dataFile: Data?
    var nameFile: String?
    var extesionFile: String?
    var inforUser: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDeleteFile.isHidden = true
        self.getInfoUser()
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
    @IBAction func doDeleteFile(_ sender: Any) {
        btnDeleteFile.isHidden = true
        btnChooseFile.setTitle("Choose file", for: .normal)
    }
    
    @IBAction func doChooseFile(_ sender: Any) {
        var documentPicker: UIDocumentPickerViewController!
                if #available(iOS 14, *) {
                    // iOS 14 & later
                    let supportedTypes: [UTType] = [UTType.image, UTType.data]
                    documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
                } else {
                    // iOS 13 or older code
                    let supportedTypes: [String] = [kUTTypeImage as String]
                    documentPicker = UIDocumentPickerViewController(documentTypes: supportedTypes, in: .import)
                }
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                documentPicker.modalPresentationStyle = .formSheet
                self.present(documentPicker, animated: true)
    }
    @IBAction func doSubmit(_ sender: Any) {
        guard let dict = inforUser else{
            return
        }
        let msg = self.validForm()
        if msg.isEmpty{
           
            var param: Parameters = [:]
            param["name"] = (dict.object(forKey: "fname") as? String ?? "") + " " + (dict.object(forKey: "lname") as? String ?? "")
            param["phone"] = (dict.object(forKey: "phone") as? String ?? "")
            param["email"] = (dict.object(forKey: "email") as? String ?? "")
            param["message"] = tvMessage.text!.trimText()
            view.endEditing(true)
            self.showBusy()
            APIHelper.shared.contactUsFile(data: dataFile, nameFile: self.nameFile ?? "", extesionFile: self.extesionFile ?? "", param: param) { success, errer in
                self.hideBusy()
                if success!{
                    self.resetAllField()
                }
                self.showAlertMessage(message: errer ?? "")
            }
        }
        else{
            self.showAlertMessage(message: msg)
        }
        
    }
    
    private func getInfoUser(){
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
      
        
        APIHelper.shared.myprofile(id: userID) { success, dict in
            if let dict = dict{
                self.inforUser = dict
            }
        }
    }
}

extension ContactUsViewController{
    private func resetAllField(){
  
        tvMessage.text = nil
        nameFile = nil
        extesionFile = nil
        dataFile = nil
        btnDeleteFile.isHidden = true
        btnChooseFile.setTitle("Choose file", for: .normal)
    }
    private func validForm()-> String{
        
        let message = tvMessage.text!.trimText()
        
        if message.isEmpty{
            return "Message is required"
        }
        if dataFile == nil{
            return "Attach is required"
        }
        return ""
    }
}


extension ContactUsViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceHolder.isHidden = textView.text!.count == 0 ? false : true
    }
}
extension ContactUsViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count > 0{
            let first = urls[0]
            btnChooseFile.setTitle(first.absoluteString, for: .normal)
            self.nameFile = first.lastPathComponent
            extesionFile = first.pathExtension
           
            btnDeleteFile.isHidden = false
            documentFromURL(pickedURL: first)
        }
    }
    
    private func documentFromURL(pickedURL: URL) {
            
            /// start accessing the resource
            let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()

            defer {
                if shouldStopAccessing {
                    pickedURL.stopAccessingSecurityScopedResource()
                }
            }
            NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (readURL) in
                do {
                        dataFile = try Data(contentsOf: readURL)
                    print("EXXX")
                    } catch {
                        print("no data")
                    }
            }
        }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        btnChooseFile.setTitle(url.absoluteString, for: .normal)
        btnDeleteFile.isHidden = false
        self.nameFile = url.lastPathComponent
        extesionFile = url.pathExtension
//        do {
//                dataFile = try Data(contentsOf: url)
//            } catch {
//                print("no data")
//            }
        documentFromURL(pickedURL: url)
    }
    
  
}
