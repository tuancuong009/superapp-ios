//
//  SplashSuperViewController.swift
//  SuperApp
//
//  Created by QTS Coder on 22/9/25.
//

import UIKit
import FirebaseRemoteConfig
class SplashSuperViewController: BaseViewController {
    var remoteConfig: RemoteConfig!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        remoteConfig = RemoteConfig.remoteConfig()
               
       let settings = RemoteConfigSettings()
       settings.minimumFetchInterval = 0 // 0 để test (prod nên để vài giờ)
       remoteConfig.configSettings = settings

       // Lấy config từ server
       fetchRemoteConfig()
    }


    func fetchRemoteConfig() {
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                print("Lỗi fetch: \(error.localizedDescription)")
                return
            }

            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                let isFirebase = self.remoteConfig["IS_FIREBASE"].boolValue
                print("Remote Config: \(isFirebase)")
                AppSettings.shared.isUseFirebase = isFirebase
                if !AppSettings.shared.isUseFirebase {
                    APP_DELEGATE.setupLocation()
                }
                let seconds = 0.5
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    if let userID = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String{
                        print(userID)
                        APP_DELEGATE.initSuperApp()
                    }
                    else{
                        APP_DELEGATE.initLoginSuper()
                    }
                  
                }
               
                
            } else {
                print("Không lấy được config")
            }
        }
    }
}
