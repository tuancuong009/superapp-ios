//
//  WebSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 1/10/25.
//

import UIKit
import WebKit
class WebSuperViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var wkWebKit: WKWebView!
    @IBOutlet weak var lblnavi: UILabel!
    var url: String = ""
    var titleNavi: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblnavi.text = titleNavi
        wkWebKit.navigationDelegate = self
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            wkWebKit.load(request)
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
    
    @IBAction func doSuper(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}
