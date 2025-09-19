//
//  CrowdFundingViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 2/8/24.
//

import UIKit
import Alamofire
import UniformTypeIdentifiers
class CrowdFundingViewController: BaseViewController {

    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    var urlFile: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAttach.titleLabel?.font = UIFont.init(name: FontName.semiBold.font, size: 17.0)
        btnDelete.isHidden = true
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
        self.navigationController?.pushViewController(NewHomeViewController.instantiate(), animated: true)
    }
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doAttachFile(_ sender: Any) {
        openDocumentPicker()
    }
    @IBAction func doSubmit(_ sender: Any) {
        if tvMessage.text!.trimmed.isEmpty{
            self.showErrorAlert(message: "Message is required")
            return
        }
//        if urlFile == nil{
//            self.showErrorAlert(message: "File is required")
//            return
//        }
        self.view.endEditing(true)
        let para = ["username": AppSettings.shared.currentUser?.username ?? "", "message_content": tvMessage.text!.trimmed]
        if let urlFile = urlFile{
            do {
                let data = NSData(contentsOf: urlFile)
                if data != nil{
                    self.showSimpleHUD()
                    ManageAPI.shared.uploadMessageContent(params: para, file: data! as Data, fileName: urlFile.lastPathComponent, mimeType: urlFile.mimeType()) { success, error in
                        self.hideLoading()
                        if success{
                            self.navigationController?.popViewController(animated: true)
                            self.showAlert(title: nil, message: "Your message has been sent successfully!")
                        }
                        else{
                            if let error = error{
                                self.self.showErrorAlert(message: error)
                            }
                        }
                    }
                }
               
            } catch {
                print ("loading image file error")
            }
           
           
        }
        else{
            self.showSimpleHUD()
            ManageAPI.shared.messageContent(params: para) { success, error in
                self.hideLoading()
                if success{
                    self.navigationController?.popViewController(animated: true)
                    self.showAlert(title: nil, message: "Your message has been sent successfully!")
                }
                else{
                    if let error = error{
                        self.self.showErrorAlert(message: error)
                    }
                }
            }
        }
        
    }
    @IBAction func doDelete(_ sender: Any) {
        btnAttach.setTitle("BROWSE", for: .normal)
        btnDelete.isHidden = true
        urlFile = nil
    }
    
    func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen

        present(documentPicker, animated: true)
    }
    func loadFileFromLocalPath(_ localFilePath: String) ->Data? {
       return try? Data(contentsOf: URL(fileURLWithPath: localFilePath))
    }
}

extension CrowdFundingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        lblPlaceHolder.isHidden = textView.hasText
    }
}
extension CrowdFundingViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let newUrls = urls.compactMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    print("Exits")
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                // Move file from app_id-Inbox to tmp/filename
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                return tempURL
            } catch {
                print("error--->",error.localizedDescription)
                return nil
            }
        }
        print("newUrls--->",newUrls)
        if newUrls.count > 0 {
            urlFile = newUrls[0]
            btnAttach.setTitle(urlFile!.lastPathComponent, for: .normal)
            btnDelete.isHidden = false
        }
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
       
    }
    
   
}

extension URL {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}
