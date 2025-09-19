//
//  DetailSpin2WinVC.swift
//  CircleCue
//
//  Created by QTS Coder on 17/04/2023.
//

import UIKit
import AVFoundation
import Lottie
class DetailSpin2WinVC: BaseViewController {
    @IBOutlet weak var spinningWheel: TTFortuneWheel!
    @IBOutlet weak var btnSpin2Win: UIButton!
    @IBOutlet weak var lblRule: UILabel!
    var player: AVAudioPlayer!
    let starAnimationView = LottieAnimationView()
    
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var viewLotte: UIView!
    @IBOutlet weak var tblWinnerList: UITableView!
    @IBOutlet weak var heightWinnerList: NSLayoutConstraint!
    var checkIsSpin = false
    var arrWinnerList = [NSDictionary]()
    var dataWin = ""
    var indexWin = -1
    var idSpin = ""
    var isLoadMore: Bool = false
    var radom = [0,2,4,6,8,10]
    var userLoginId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        userLoginId = userId
       // let randomInt = Int.random(in: 1..<2000)
        //userLoginId = "\(randomInt)"
        tblWinnerList.registerNibCell(identifier: "WinnerCell")
        apiCheckPin()
        viewLotte.alpha = 0.0
        self.setupLotte()
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        btnSpin2Win.layer.cornerRadius = 45
        btnSpin2Win.layer.masksToBounds = true
        btnSpin2Win.backgroundColor = .init(hex: "E4AD3F")
        btnSpin2Win.layer.borderWidth = 6.0
        btnSpin2Win.layer.borderColor = UIColor(hex: "0C1D33").cgColor
        let slices = [ CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$5"),
                       CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$5"),
                       CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$10"),
                       CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$15"),
                       CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$20"),
                       CarnivalWheelSlice.init(title: "TRY NEXT TIME"),
                       CarnivalWheelSlice.init(title: "$25")
        ]
        spinningWheel.initialDrawingOffset = 180.0
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 0
        spinningWheel.titleRotation = CGFloat.pi
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 4 {
            case 0:
                slice.style = .brickRed
            case 1:
                slice.style = .sandYellow
            case 2:
                slice.style = .babyBlue
            case 3:
                slice.style = .deepBlue
            default:
                slice.style = .brickRed
            }
        }
        btnMore.isHidden = true
        heightWinnerList.constant = 0
        ManageAPI.shared.winnerList { users, error in
            self.arrWinnerList = users
            self.tblWinnerList.reloadData()
            self.updateUIWinnerList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        starAnimationView.frame = self.viewLotte.frame
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ditapMore(_ sender: Any) {
        isLoadMore = true
        tblWinnerList.reloadData()
        updateUIWinnerList()
    }
    @IBAction func rotateButton(_ sender: Any) {
        self.apiAddSpin()
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension DetailSpin2WinVC{
    func setupLotte(){
        starAnimationView.frame = self.viewLotte.frame
        self.viewLotte.addSubview(starAnimationView)
        if let path = Bundle.main.path(forResource: "congratulations", ofType: "json") {
            let animation = LottieAnimation.filepath(path, animationCache: .none)
            starAnimationView.animation = animation
            starAnimationView.animationSpeed = 0.9
        }
    }
    
    func configAnimation(_ title: String)
    {
        self.viewLotte.alpha = 1.0
        playSound(soundName: "success", isError: true)
        starAnimationView.play { (success) in
            self.starAnimationView.currentTime = 0
            self.viewLotte.alpha = 0.0
            let vc = PaymentSpin2WinVC.init()
            vc.price = title
            vc.spin_id = self.idSpin
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
    func playSound(soundName: String, isError: Bool = false) {
        if isError{
            let url = Bundle.main.url(forResource: soundName, withExtension: ".wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
        else{
            let url = Bundle.main.url(forResource: soundName, withExtension: ".mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
    private func apiCheckPin(){
        btnSpin2Win.isUserInteractionEnabled = false
        ManageAPI.shared.checkSpinStatus(userId: userLoginId) { result, error in
            self.hideLoading()
            self.btnSpin2Win.isUserInteractionEnabled = true
            if result{
                if let error = error{
                    self.checkIsSpin = (error == "1" ? true : false)
                }
                print("self.checkIsSpin--->",self.checkIsSpin)
            }
        }
    }
    
    private func apiAddSpin(){
        if self.checkIsSpin{
            showSimpleHUD()
            ManageAPI.shared.addSpin(userId: userLoginId) { result, spinId, error in
                self.hideLoading()
                self.idSpin = spinId ?? ""
                if let result = result{
                    var postion = 0
                    for item in self.spinningWheel.slices{
                        let title = item.title.replacingOccurrences(of: "$", with: "")
                        if title.lowercased() == result.lowercased(){
                            self.indexWin = postion
                            break
                        }
                        postion = postion + 1
                    }
                    if self.indexWin == -1{
                        self.indexWin = self.radom.randomElement() ?? 0
                    }
                    if self.indexWin >= 0{
                        self.checkIsSpin =  false
                        self.playWin()
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.showErrorAlert(title: "Oops!", message: "You already Spun. Please try again tomorrow.\nGood Luck")
                    }
                }
            }
        }
        else{
            self.showErrorAlert(title: "Oops!", message: "You already Spun. Please try again tomorrow.\nGood Luck")
            
        }
    }
    
    private func playWin(){
        playSound(soundName: "spinning", isError: false)
        btnSpin2Win.isUserInteractionEnabled = false
        spinningWheel.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.spinningWheel.startAnimating(fininshIndex: self.indexWin) { (finished) in
                let title = self.spinningWheel.slices[self.indexWin].title
                self.btnSpin2Win.isUserInteractionEnabled = true
                if title == "TRY NEXT TIME"{
                    self.playSound(soundName: "error", isError: true)
                    self.showAlert(title: "Oops!", message: "Sorry you didn't win today. Please try again tomorrow.\nGood Luck", buttonTitles: ["OK"], highlightedButtonIndex: nil) { _ in
                    }
                }
                else{
                    self.configAnimation(title)
                }
            }
        }
    }
    
    private func updateUIWinnerList(){
        if arrWinnerList.count <= 3{
            btnMore.isHidden = true
            self.heightWinnerList.constant = CGFloat(arrWinnerList.count*35)
        }
        else{
            if !isLoadMore{
                btnMore.isHidden = false
                self.heightWinnerList.constant = CGFloat(3*35)
            }
            else{
                btnMore.isHidden = true
                self.heightWinnerList.constant = CGFloat(arrWinnerList.count*35)
            }
        }
    }
}


extension DetailSpin2WinVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrWinnerList.count == 0{
            return 0
        }
        if isLoadMore{
            return arrWinnerList.count
        }
        else{
            if arrWinnerList.count > 3{
                return 3
            }
            return arrWinnerList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblWinnerList.dequeueReusableCell(withIdentifier: "WinnerCell") as! WinnerCell
        let dict = arrWinnerList[indexPath.row]
        cell.lblUserName.text = dict.object(forKey: "name") as? String
        cell.lblPrice.text = "$" + (dict.object(forKey: "price") as? String ?? "0")
        return cell
    }
}
