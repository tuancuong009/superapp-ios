//
//  LiveStreamListVC.swift
//  CircleCue
//
//  Created by QTS Coder on 31/05/2024.
//

import UIKit
import SwiftUI
import ZegoUIKit
import ZegoUIKitPrebuiltLiveStreaming
class LiveStreamListVC: BaseViewController {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblData: UITableView!
    var arrLives = [NSDictionary]()
    var streamId = ""
    var radomString = ""
    var zegoUIKitPrebuiltLiveStreamingVC: ZegoUIKitPrebuiltLiveStreamingVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblData.registerNibCell(identifier: "LiveStreamTableViewCell")
        updateUINoData()
        topBarMenuView.rightButtonType = 1
        self.lblNoData.isHidden = true
        getApi()
        // Do any additional setup after loading the view.
    }
    override func addNote() {
        radomString = self.randomString(length: 10)
        
        self.liveStreamHost(radomString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    private func updateUINoData(){
        guard let user = AppSettings.shared.currentUser else{
            return
        }
        if user.accountType == .business{
            lblNoData.text = "Click on the + icon to go LIVE and interact with CircleCue users. Showcase your products and services. Any nudity will result in your account being permanently banned."
        }
        else{
            lblNoData.text = "Click on the + icon to go LIVE and interact with CircleCue users. Any nudity will result in your account being permanently banned."
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
    
}

extension LiveStreamListVC{
    private func getApi(){
        showSimpleHUD()
        ManageAPI.shared.liveStreamList { arrs, error in
            self.hideLoading()
            if let arrs = arrs{
                self.arrLives = arrs
            }
            self.tblData.reloadData()
            self.lblNoData.isHidden =  self.arrLives.count == 0 ? false :true
            self.tblData.isHidden =  self.arrLives.count == 0 ? true :false
        }
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    private func callApiCreateStream(_ radomString: String){
        self.showSimpleHUD()
        ManageAPI.shared.livestreamSubmit(stream_id: radomString, status: "1") { streamKey, error in
            self.hideLoading()
            if let key = streamKey{
                self.streamId = key
                print("StreamID--->",self.streamId)
            }
        }
    }
    
    func liveStreamHost(_ radomString: String){
        guard let user = AppSettings.shared.currentUser else{
            return
        }
       
        let userID: String = user.userId ?? ""
        let userName: String = user.username ?? ""
        let liveID: String = radomString
        let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host()
        
        zegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(UInt32(AppConfiguration.yourAppID), appSign: AppConfiguration.yourAppSign, userID: userID , userName: userName + "=" + (user.pic ?? ""), liveID: liveID, config: config, user.pic ?? "")
        zegoUIKitPrebuiltLiveStreamingVC.modalPresentationStyle = .fullScreen
        zegoUIKitPrebuiltLiveStreamingVC.delegate = self
        let nav = UINavigationController(rootViewController: zegoUIKitPrebuiltLiveStreamingVC)
        nav.isNavigationBarHidden = true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true) {
        }
    }
}
extension LiveStreamListVC: ZegoUIKitPrebuiltLiveStreamingVCDelegate{
    
    func onLeaveLiveStreaming() {
        zegoUIKitPrebuiltLiveStreamingVC.dismiss(animated: true)
        ZegoUIKit.shared.sendInRoomMessage("has left")
        self.getApi()
    }
    
    func onLiveStreamingEnded() {
        print("streamId--->",streamId)
        if !streamId.isEmpty{
            ManageAPI.shared.deleteStream(id: streamId) { error in
                self.getApi()
            }
        }
        else{
            let alert = UIAlertController(title: "CircleCue", message: "The live is ended", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { action in
                self.zegoUIKitPrebuiltLiveStreamingVC.dismiss(animated: true)
                self.getApi()
            }
            alert.addAction(ok)
            zegoUIKitPrebuiltLiveStreamingVC.present(alert, animated: true)
           
        }
    }
    
    func onStartLiveButtonPressed() {
       
        callApiCreateStream(radomString)
    }
    
    
    func onInRoomMessageClick(_ message: ZegoInRoomMessage) {
        guard let user = AppSettings.shared.currentUser else{
            return
        }
        guard let messageUser = message.user else{
            return
        }
        print("messageUser.userID",messageUser.userID, user.userId)
        if messageUser.userID != user.userId{
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: messageUser.userID, username: messageUser.userName, country: "", pic: "")
            zegoUIKitPrebuiltLiveStreamingVC.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func viewProfileHost(_ userInfo: ZegoUIKitUser) {
        guard let user = AppSettings.shared.currentUser else{
            return
        }
           
        if userInfo.userID != user.userId{
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: userInfo.userID, username: userInfo.userName, country: "", pic: "")
            zegoUIKitPrebuiltLiveStreamingVC.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
extension LiveStreamListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLives.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblData.dequeueReusableCell(withIdentifier: "LiveStreamTableViewCell") as! LiveStreamTableViewCell
        let dict = arrLives[indexPath.row]
        if let username = dict.object(forKey: "username") as? String{
            cell.lblUserName.text = username + " is live now..."
        }
        else{
            cell.lblUserName.text = ""
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = arrLives[indexPath.row]
//        if let stream_id = dict.object(forKey: "id") as? String{
//            ManageAPI.shared.deleteStream(id: stream_id) { error in
//                self.getApi()
//            }
//        }
//       
        if let stream_id = dict.object(forKey: "stream_id") as? String{
         
            guard let user = AppSettings.shared.currentUser else{
                return
            }
            let userID: String = user.userId ?? ""
            let userName: String = user.username ?? ""
            let liveID: String = stream_id
            let config: ZegoUIKitPrebuiltLiveStreamingConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience()
            zegoUIKitPrebuiltLiveStreamingVC = ZegoUIKitPrebuiltLiveStreamingVC(UInt32(AppConfiguration.yourAppID), appSign: AppConfiguration.yourAppSign, userID: userID, userName: userName, liveID: liveID, config: config, user.pic ?? "")
            zegoUIKitPrebuiltLiveStreamingVC.modalPresentationStyle = .fullScreen
            zegoUIKitPrebuiltLiveStreamingVC.delegate = self
            let nav = UINavigationController(rootViewController: zegoUIKitPrebuiltLiveStreamingVC)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true) {
                ZegoUIKit.shared.sendInRoomMessage("joined")
            }
            
        }
    }
    
}
