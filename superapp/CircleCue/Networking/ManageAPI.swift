//
//  ManageAPI.swift
//  CircleCue
//
//  Created by QTS Coder on 10/30/20.
//

import UIKit
import Alamofire

class ManageAPI {
    static let shared = ManageAPI()
    
    private var sessionManager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        sessionManager = Session(configuration: configuration)
    }

    // MARK: - UPLOAD FILE
    
    func uploadFile(file: Data, _ fileName: String, _ type: MediaUploadType = .image, _ completion: @escaping (_ path: String?, _ error: String?) -> Void) {
        let mimeType = type.mimeType
        AF.upload(multipartFormData: { (data) in
            data.append(file, withName: "ionicfile", fileName: fileName, mimeType: mimeType)
        }, to: EndpointURL.upload.url, method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            LOG("\n--> FILE NAME = \(fileName))\n\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true, let path = data.value(forKey: "path") as? String {
                    if let url = URL(string: path) {
                        return completion(url.lastPathComponent, nil)
                    }
                    var shortPath = path.replacingOccurrences(of: Constants.UPLOAD_URL_RETURN, with: "")
                    shortPath = path.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                    return completion(shortPath, nil)
                }
                return completion(nil, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - AUTHENTICATIONS
    
    func login(_ para: Parameters, completion: @escaping (_ userId: String?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.login.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                
                if let Status = data.value(forKey: "Status") as? Bool, Status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    let user = UserLogin(dic: data)
                    AppSettings.shared.userLogin = user
                    completion(user.userId, nil)
                } else {
                    completion(nil, data.value(forKey: "Message") as? String)
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func loginWithSocial(_ para: Parameters, _ completion: @escaping (_ userId: String?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.login_with_social.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                    var userId: String = ""
                    if let id = data.value(forKey: "Data") as? String, !id.isEmpty {
                        userId = id
                    } else if let id = data.value(forKey: "Data") as? Int {
                        userId = "\(id)"
                    }
                    
                    if !userId.isEmpty {
                        let user = UserLogin(dic: data)
                        AppSettings.shared.userLogin = user
                        completion(userId, nil)
                        return
                    }
                }
                
                completion(nil, data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func verifyEmail(email: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["email": email]
        sessionManager.request(EndpointURL.verifyEmail.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func verifyUsername(username: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["username": username]
        sessionManager.request(EndpointURL.verifyUserName.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func register(_ para: Parameters, completion: @escaping (_ uid: Int?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.register.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true, let uid = data.value(forKey: "Data") as? Int {
                    completion(uid, nil)
                } else {
                    completion(nil, data.value(forKey: "Message") as? String)
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func registerBusiness(_ para: Parameters, completion: @escaping (_ uid: Int?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.registerBusiness.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true, let uid = data.value(forKey: "Data") as? Int {
                    completion(uid, nil)
                } else {
                    completion(nil, data.value(forKey: "Message") as? String)
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func resetPassword(_ userName: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userName, "type": 2]
        sessionManager.request(EndpointURL.login.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func createSubscribe(para: Parameters, completion: @escaping (_ result: Bool, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.createSubscribe.url, method: .post, parameters: para).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let json = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                
                guard let status = json.value(forKey: "Status") as? Bool, status == true else {
                    return completion(false, json.value(forKey: "Message") as? String)
                }
                completion(true, nil)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func cancelSubscribe(para: Parameters, completion: @escaping (_ result: Bool, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.cancelSubscribe.url, method: .post, parameters: para).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let json = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                
                guard let status = json.value(forKey: "Status") as? Bool, status == true else {
                    return completion(false, json.value(forKey: "Message") as? String)
                }
                completion(true, json.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    // MARK: - USER INFORMATION
    
    func fetchUserInfo(_ userId: String, completion: @escaping (_ user: UserInfomation?, _ error: String?) -> Void) {
        var para: Parameters = ["id": userId]
        if let location = AppSettings.shared.currentLocation {
            para.updateValue(location.coordinate.latitude, forKey: "lat")
            para.updateValue(location.coordinate.longitude, forKey: "lng")
        }
        sessionManager.request(EndpointURL.profileInfo.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], let user = data.first else {
                    return completion(nil, response.error?.localizedDescription)
                }
                completion(UserInfomation.init(dic: user, userId: userId), nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func viewUserProfile(_ userId: String?, otherUserId: String, completion: @escaping (_ user: UserInfomation?, _ error: String?) -> Void) {
        var para: Parameters = ["id": otherUserId]
        if let userID = userId {
            para.updateValue(userID, forKey: "id2")
            para.updateValue("1", forKey: "type")
        }
        sessionManager.request(EndpointURL.profileInfo.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], let user = data.first else {
                    return completion(nil, response.error?.localizedDescription)
                }
                completion(UserInfomation.init(dic: user, userId: otherUserId), nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func updateUserAvatar(_ userId: String, pic: String, _ completion: @escaping (_ error: ErrorModel?) -> Void) {
        let para: Parameters = ["pic": pic, "id": userId]
        sessionManager.request(EndpointURL.updateAvatar.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func updateUserInfo(_ para: Parameters, completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.updateProfile.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func changePassword(_ para: Parameters?, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.changePassword.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchUserCustomLink(_ userId: String, _ completion: @escaping (_ results: [CustomLink]) -> Void) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.customlink.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], let _ = data.first?.value(forKey: "id") as? String else {
                    return completion([])
                }
                completion(data.compactMap({CustomLink.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func fetchVisitors(_ userId: String, _ completion: @escaping (_ result: [Visitor]) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.visitor.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                completion(data.compactMap({Visitor.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func fetchListRead(_ userId: String, _ completion: @escaping (_ result: Int) -> Void) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.listread.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary, let number = data.value(forKey: "Data") as? Int else {
                    return completion(0)
                }
                completion(number)
            case .failure(_):
                completion(0)
            }
        }
    }
    
    func updateResume(_ para: Parameters?, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.updateresume.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteResume(_ userId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.deleteresume.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func updateUserGender(_ userId: String, gender: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "gender": gender]
        sessionManager.request(EndpointURL.update_gender.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func updateUserLoginStatus(_ userId: String) {
        let para: Parameters = ["userid": userId]
        sessionManager.request(EndpointURL.update_login_status.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
        }
    }
    
    func fetchAccountStatus(userId: String, completion: @escaping (_ status: AccountStatus?) -> Void) {
        let url = EndpointURL.accountStatus(userId).url
        sessionManager.request(url).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil)
                }
                if let message = data.value(forKey: "Message") as? String, let messageId = message.int, let status = AccountStatus(rawValue: messageId) {
                    return completion(status)
                }
                completion(nil)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func updateAccountStatus(userId: String, status: String, completion: @escaping (_ error: String?) -> Void) {
        let url = EndpointURL.updateAccountStatus(userId, status).url
        sessionManager.request(url).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteAccount(userId: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        let url = EndpointURL.deleteAccount(userId, password).url
        sessionManager.request(url).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    // MARK: - Check Spin
    func checkSpinStatus(userId: String, completion: @escaping (_ isResult: Bool, _ error: String?) -> Void) {
        let url = EndpointURL.checkspin.url
        let para: Parameters = ["uid": userId]
        sessionManager.request(url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, nil)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(true, data.value(forKey: "Message") as? String)
                }
                completion(false, data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add Spin
    func addSpin(userId: String, completion: @escaping (_ result: String?, _ spinId: String?, _ error: String?) -> Void) {
        let url = EndpointURL.addspin.url
        let para: Parameters = ["uid": userId]
        sessionManager.request(url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, nil, nil)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    if let  Data = data.object(forKey: "Data") as? Int{
                        return completion("\(Data)", data.object(forKey: "id") as? String, data.value(forKey: "Message") as? String)
                    }
                    
                    return completion(data.value(forKey: "Data") as? String, data.object(forKey: "id") as? String, data.value(forKey: "Message") as? String)
                }
               
                completion(nil, nil, data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(nil, nil, error.localizedDescription)
            }
        }
    }
    
    // MARK: - add winner
    func addWinner(_ para: Parameters, completion: @escaping ( _ error: String?) -> Void) {
        let url = EndpointURL.addwinner.url
        sessionManager.request(url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    // MARK: - BLOCK USER
    
    func checkBlock(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ status: Bool) -> Void) {
        let para: Parameters = ["sid": userId, "rid": otherUserId]
        sessionManager.request(EndpointURL.checkblock.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion(false)
                }
                if let block = data.first?.value(forKey: "block") as? Int, block == 1 {
                    return completion(true)
                }
                completion(false)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func blockUser(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": otherUserId]
        sessionManager.request(EndpointURL.block.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func unblockUser(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": otherUserId]
        sessionManager.request(EndpointURL.unblock.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SEARCH
    
    func search(_ para: Parameters? = nil, completion: @escaping (_ result: [UniversalUser], _ error: String?) -> Void ) {
        sessionManager.request(EndpointURL.search.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({UniversalUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func searchReviews(_ para: Parameters? = nil, completion: @escaping (_ results: [Review], _ error: String?) -> Void ) {
        sessionManager.request(EndpointURL.search_reviews.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({Review.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func searchCircleUser(_ para: Parameters? = nil, completion: @escaping (_ result: [UniversalUser], _ error: String?) -> Void ) {
        sessionManager.request(EndpointURL.search_dating_circle.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({UniversalUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func searchJobs(_ para: Parameters? = nil, completion: @escaping (_ result: [SearchJob], _ error: String?) -> Void ) {
        sessionManager.request(EndpointURL.search_job.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({SearchJob.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func searchResumes(_ para: Parameters? = nil, completion: @escaping (_ result: [SearchResume], _ error: String?) -> Void ) {
        sessionManager.request(EndpointURL.search_resume.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({SearchResume.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    // MARK: - FOLLOWING
    
    func addFollowingUser(fromUser: String, toUser: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["fromid": fromUser, "toid": toUser]
        sessionManager.request(EndpointURL.addFollowUser.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func unFollowUser(fromUser: String, toUser: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": fromUser, "id2": toUser]
        sessionManager.request(EndpointURL.unFollowUser.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchFollowingUsers(userId: String, _ completion: @escaping (_ users: [FollowingUser], _ error: String?) -> Void) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.getFollowingUsers.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({FollowingUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func fetchFollowerUsers(userId: String, _ completion: @escaping (_ users: [FollowingUser], _ error: String?) -> Void) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.getFollowerUser.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({FollowingUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    // MARK: - MY CIRCLE
    
    func fetchCircleUsers(userId: String, _ completion: @escaping (_ users: [CircleUser], _ error: String?) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.inCircleUser.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({CircleUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    func fetchTotaLikes(userId: String, _ completion: @escaping (_ users: [CircleUser], _ error: String?) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.totalLikeProfile.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({CircleUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func sendCircleRequest(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": otherUserId]
        sessionManager.request(EndpointURL.addtocircle.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func declineCircleRequest(_ requestId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": requestId]
        sessionManager.request(EndpointURL.declineRequest.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func acceptCircleRequest(_ requestId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": requestId]
        sessionManager.request(EndpointURL.acceptRequest.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - FAVORITES
    
    func fetchFavoriteUsers(userId: String, _ completion: @escaping (_ users: [UniversalUser], _ error: String?) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.favouritelist.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({UniversalUser.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func addFavoriteUser(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": otherUserId]
        sessionManager.request(EndpointURL.addtofav.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func removeFavoriteUser(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": otherUserId]
        sessionManager.request(EndpointURL.removetofav.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - MESSAGES/CHATS
    
    func fetchUserMessageList(_ userId: String, page: Int = 1, _ completion: @escaping (_ results: [MessageDashboard]) -> Void) {
        let para: Parameters = ["sid": userId, "page": page]
        sessionManager.request(EndpointURL.messagelist.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                completion(data.compactMap({MessageDashboard.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func fetchMessageBetweenUser(_ userId: String, _ otherUserId: String, _ completion: @escaping (_ userMessage: UserMessage?, _ error: String?) -> Void) {
        let para: Parameters = ["sid": userId, "rid": otherUserId]
        sessionManager.request(EndpointURL.messsagebetweenusers.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    if let _ = value as? [NSDictionary] {
                        return completion(nil, nil)
                    }
                    return completion(nil, response.error?.localizedDescription)
                }
                completion(UserMessage(dic: data), nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func sendMessageToUser(para: Parameters?, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.sendMessage.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteMessage(_ messageId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": messageId]
        sessionManager.request(EndpointURL.deleteMessage.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func archiveMessage(from userId: String, to id: String, completion: @escaping (_ error: String?) -> Void) {
        let url = EndpointURL.archiveMessage(userId, id).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - NOTES/REMINDERS
    
    func fetchNoteList(userId: String, completion: @escaping (_ result: [Note], _ error: String?) -> Void ) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.listnotes.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(data.compactMap({Note.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func addNewNote(para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addnote.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteNote(userId: String, noteId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["val": userId, "val2": noteId]
        sessionManager.request(EndpointURL.deletenote.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - NEARBY USER
    
    func fetchNearByUsers(userId: String, completion: @escaping (_ result: [NearestUser], _ error: String?) -> Void ) {
        let para: Parameters = ["id": userId]
        sessionManager.request(EndpointURL.nearestUsers.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion([], response.error?.localizedDescription)
                }
                if let map = data.value(forKey: "map") as? [NSDictionary] {
                    return completion(map.compactMap({NearestUser.init(dic: $0)}), nil)
                }
                completion([], nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    // MARK: - CONTACT US/HELP
    
    func submitContactUs(_ userId: String, _ desc: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["uid": userId, "desc": desc]
        sessionManager.request(EndpointURL.submitContact.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true, let message = data.value(forKey: "Message") as? String, message == "1" {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - ALBUM/GALLERY
    
    func fetchGallery(userId: String, completion: @escaping (_ result: [Gallery], _ error: String?) -> Void ) {
        let para: Parameters = ["uid": userId]
        sessionManager.request(EndpointURL.gallery.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                let gallery = data.compactMap({Gallery.init(dic: $0)})
                completion(gallery, nil)
                let videos = gallery.filter({$0.albumType == .video})
                if !videos.isEmpty {
                    for video in videos {
                        if !video.pic.isEmpty {
                            VideoThumbnail.shared.preloadThumbnailVideo(video.pic)
                        }
                    }
                }
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func addNewGalleryPhoto(para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addAlbumPhoto.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteGalleryPhoto(userId: String, photoId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["uid": userId, "id": photoId]
        sessionManager.request(EndpointURL.deleteAlbumPhoto.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func changePhotoStatus(photoId: String, status: Bool, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": photoId, "showOnFeed": status ? 1 : 0]
        sessionManager.request(EndpointURL.update_photo_status.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - REVIEWS
    
    func fetchBusinessUserList(_ completion: @escaping (_ users: [BusinessUserObject]) -> Void) {
        sessionManager.request(EndpointURL.userlistbusiness.url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                completion(data.compactMap({BusinessUserObject.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func addReview(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addreviews.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchMyReviews(_ userId: String, isBusiness: Bool = false, _ completion: @escaping (_ results: [Review]) -> Void) {
        var para: Parameters = [:]
        if isBusiness {
            para = ["id2": userId]
        } else {
            para = ["id": userId]
        }
        
        sessionManager.request(EndpointURL.reviewfetch.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                let result = data.compactMap({Review.init(dic: $0)}).sorted(by: {$0.id > $1.id})
                completion(result)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func deleteReview(_ id: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": id]
        sessionManager.request(EndpointURL.reviewdelete.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func updateReview(para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.reviewupdate.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func replyReview(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.reviewrply.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - BLOG/NEWS ARTICLES
    
    func addBlog(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addblog.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchBlog(_ userId: String, _ completion: @escaping (_ results: [Blog_Job]) -> Void) {
        let para: Parameters = ["uid": userId]
        sessionManager.request(EndpointURL.blogfetch.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                let result = data.compactMap({Blog_Job.init(dic: $0)}).sorted(by: {$0.id > $1.id})
                completion(result)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func updateBlog(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.blogupdate.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteBlog(_ id: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": id]
        sessionManager.request(EndpointURL.blogdelete.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func searchEvent(query: String, completion: @escaping (_ results: [Blog_Job]) -> Void) {
        let para: Parameters = ["search": query]
        sessionManager.request(EndpointURL.blogfetch.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                let result = data.compactMap({ Blog_Job.init(dic: $0)}).sorted(by: {$0.id > $1.id })
                completion(result)
            case .failure(_):
                completion([])
            }
        }
    }
    
    // MARK: - JOB Postings
    
    func addJob(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addjob.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchJobs(_ userId: String, _ completion: @escaping (_ results: [Blog_Job]) -> Void) {
        let para: Parameters = ["uid": userId]
        sessionManager.request(EndpointURL.jobfetch.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                let result = data.compactMap({Blog_Job.init(dic: $0)}).sorted(by: {$0.id > $1.id})
                completion(result)
            case .failure(_):
                completion([])
            }
        }
    }
    
    func updateJob(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.jobupdate.url, method: .get, parameters: para, encoding: URLEncoding.default).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func deleteJob(_ id: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": id]
        sessionManager.request(EndpointURL.jobdelete.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - DATING CIRCLE
    
    func updateMyDatingStatus(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.update_my_dating_status.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getUserCircleStatusBetweenUsers(_ para: Parameters, _ completion: @escaping (_ data: UserCircleObject?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.get_dating_status_between_users.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, response.error?.localizedDescription)
                }
                if let _ = data.string(forKey: "id") {
                    return completion(UserCircleObject(dic: data), nil)
                }
                completion(nil, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(nil ,error.localizedDescription)
            }
        }
    }
    
    func addDatingStatusBetweenUsers(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.add_dating_status_between_users.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func updateDatingStatusBetweenUsers(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.update_dating_status_between_users.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - DINNER CIRCLE
    
    func updateDinnerCircleStatus(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.updateDineoutCircle.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func addDinnerStatusBetweenUsers(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addDineStatus.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - TRAVEL CIRCLE
    
    func updateTravelCircleStatus(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.updateTravelCircle.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func addTravelStatusBetweenUsers(_ para: Parameters, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.addTravelStatus.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - MANAGE PRIVACY
    
    func fetchPrivacy(_ userId: String, partnerId: String, _ completion: @escaping (_ result: UserInfomation?) -> Void) {
        let para: Parameters = ["id": userId, "id2": partnerId]
        sessionManager.request(EndpointURL.getprivacy.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary],
                      let privacy = data.last,
                      let email = privacy.value(forKey: "email") as? String, !email.isEmpty  else {
                    return completion(nil)
                }
                completion(UserInfomation.init(dic: privacy, isPrivacy: true))
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func likeProfile(_ userId: String, partnerId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": partnerId]
        sessionManager.request(EndpointURL.likeProfile.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(_):
                completion(nil)
            }
        }
    }
    func unlikeProfile(_ userId: String, partnerId: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["id": userId, "id2": partnerId]
        sessionManager.request(EndpointURL.unlikeProfile.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(_):
                completion(nil)
            }
        }
    }
    func updatePrivacy(para: Parameters?, _ completion: @escaping (_ error: String?) -> Void) {
        sessionManager.request(EndpointURL.updateprivacy.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    // MARK: - FEED PAGE
    
    func fetchShowCase(_ para: Parameters?, _ completion: @escaping (_ results: [UniversalUser]) -> Void) {
        sessionManager.request(EndpointURL.showcase.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([])
                }
                completion(data.compactMap({UniversalUser.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func fetchNewFeed(_ userId: String?, page: Int, type: FeedType, searchQuery: String, _ completion: @escaping (_ results: [NewFeed], _ hasMore: Bool, _ error: ErrorModel?) -> Void) {
        var para: Parameters = ["page": page, "username": searchQuery]
        var url = EndpointURL.new_feed.url
        if let userId = userId {
            para.updateValue(userId, forKey: "uid")
        }
        
        switch type {
        case .personal, .business:
            para.updateValue(type.rawValue, forKey: "type")
        case .vclips:
            url = EndpointURL.feed_clip.url
        case .all:
            break
        }
        
        sessionManager.request(url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([], false, nil)
                }
                let results = data.compactMap({ NewFeed(dic: $0) })
                completion(results, true, nil)
            case .failure(let error):
                completion([], false, ErrorManager.processError(error: error))
            }
        }
    }
    
    func fetchNewFeedStories(_ userId: String?, page: Int, type: FeedType, searchQuery: String, _ completion: @escaping (_ results: [NewFeed], _ hasMore: Bool, _ error: ErrorModel?) -> Void) {
        var para: Parameters = ["page": page, "username": searchQuery ,"stay": 1]
        var url = EndpointURL.new_feed.url
        if let userId = userId {
            para.updateValue(userId, forKey: "uid")
        }
        
        switch type {
        case .personal, .business:
            para.updateValue(type.rawValue, forKey: "type")
        case .vclips:
            url = EndpointURL.feed_clip.url
        case .all:
            break
        }
        
        sessionManager.request(url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([], false, nil)
                }
                let results = data.compactMap({ NewFeed(dic: $0) })
                completion(results, true, nil)
            case .failure(let error):
                completion([], false, ErrorManager.processError(error: error))
            }
        }
    }
    
    // MARK: - PHOTO COMMENT/LIKE
    
    func fetchPhotoComments(_ photoId: String, _ completion: @escaping (_ results: [PhotoComment], _ error: ErrorModel?) -> Void) {
        let para: Parameters = ["id": photoId]
        sessionManager.request(EndpointURL.fetch_comment.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let value = value as? NSDictionary, let data = value.value(forKey: "Data") as? [NSDictionary] else {
                    return completion([], ErrorManager.processError())
                }
                completion(data.compactMap({PhotoComment.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func addPhotoComment(_ para: Parameters?,  completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.add_comment.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func deletePhotoComment(_ para: Parameters?, completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.delete_comment.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func editPhotoComment(_ para: Parameters, completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.update_comment.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func fetchPhotoLikes(_ photoId: String, _ completion: @escaping (_ results: [PhotoLike], _ error: ErrorModel?) -> Void) {
        let para: Parameters = ["id": photoId]
        sessionManager.request(EndpointURL.fetch_like.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let value = value as? NSDictionary, let data = value.value(forKey: "Data") as? [NSDictionary] else {
                    return completion([], ErrorManager.processError())
                }
                completion(data.compactMap({PhotoLike.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func likePhoto(shouldLike: Bool, _ para: Parameters, _ completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = shouldLike ? EndpointURL.like_photo.url : EndpointURL.unlike_photo.url
        sessionManager.request(url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    // MARK: - CIRCULAR CHAT
    
    func fetchCircularMessage(_ userId: String, _ completion: @escaping (_ results: [CircularMessage], _ error: ErrorModel?) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(EndpointURL.circular_list.url, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return completion([], ErrorManager.processError())
                }
                completion(data.compactMap({CircularMessage.init(dic: $0)}), nil)
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func sendCircularMessage(_ para: Parameters?, completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.send_circular_chat.url, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    // MARK: - UPDATE TOKEN
    
    func updateUserToken(_ token: String, userId: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.update_token(token, userId).url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func updatePushNotificationStatus(userId: String, status: Int, completion: @escaping (_ error: ErrorModel?) -> Void) {
        sessionManager.request(EndpointURL.updatePushReceiveStatus(userID: userId, status: status).url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    // MARK: - NOTIFICATIONS
    
    func fetchNotification(for userId: String, completion: @escaping (_ list: [NotificationObject], _ error: ErrorModel?) -> Void) {
        let url = EndpointURL.notification(userId).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion([], ErrorManager.processError())
                }
                
                guard let notification = data.arrayDictionary(forKey: "Data") else {
                    return completion([], ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
                }
                completion(notification.compactMap({NotificationObject.init(dic: $0)}), nil)
                
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func makeNotificationAsSeen(id: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.makeNotificationSeen(id).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func deleteNotification(id: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.deleteNotification(id).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func submitUserSource(id: String, source: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.userSource.url
        let para: Parameters = ["id": id, "user_src": source]
        sessionManager.request(url, parameters: para).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func sendSignUpNotification(id: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.signup_notification(id).url
        sessionManager.request(url).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func increaseProfileViewer(userId: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.increaseProfileViewer(userId).url
        sessionManager.request(url).responseJSON { response in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func winnerList( _ completion: @escaping (_ users: [NSDictionary], _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.winnerlist.url, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion([], response.error?.localizedDescription)
                }
                guard let datas = data.object(forKey: "Data") as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(datas, nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func winnerHistory(userId: String, completion: @escaping (_ users: [NSDictionary], _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.winnerhistory(userId).url, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion([], response.error?.localizedDescription)
                }
                guard let datas = data.object(forKey: "data") as? [NSDictionary] else {
                    return completion([], response.error?.localizedDescription)
                }
                completion(datas, nil)
            case .failure(let error):
                completion([], error.localizedDescription)
            }
        }
    }
    
    func chatTokenUser(userId: String, _ completion: @escaping (_ token: String?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.streamChatToken(userId).url, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return
                }
                completion(data.object(forKey: "Data") as? String ?? "", nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    func livestreamSubmit(stream_id: String, status: String, _ completion: @escaping (_ streamKey: String?, _ error: String?) -> Void) {
        guard let user = AppSettings.shared.currentUser else { return }
        let param = ["stream_id": stream_id, "status": status, "userid": user.userId, "username": user.username ?? ""]
        sessionManager.request(EndpointURL.liveStreamSubmit.url, method: .post, parameters: param).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(param) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return
                }
                var streamKey = ""
                if let streamId = data.object(forKey: "message") as? String{
                    print("streamId---->",streamId)
                    streamKey = streamId
                }
                else if let streamId = data.object(forKey: "message") as? Int{
                    print("streamId---->",streamId)
                    streamKey = "\(streamId)"
                }
                completion(streamKey, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func liveStreamList(_ completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.getLiveStream.url, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func deleteStream(id: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = EndpointURL.deleteStream(id).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func welcomeNotification(completion: @escaping (_ error: String?) -> Void) {
        guard let user = AppSettings.shared.currentUser else { return }
        let param = ["id": user.userId]
        sessionManager.request(EndpointURL.wellcome_notification.url, method: .post, parameters: param).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(param) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                print("VALUES--->",value)
                completion(nil)
            case .failure(let error):
                completion( error.localizedDescription)
            }
        }
    }
    
    
    // MARK: - Message Content
    
    func uploadMessageContent(params: [String: String], file: Data, fileName: String, mimeType: String, _ completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        AF.upload(multipartFormData: { (data) in
            data.append(file, withName: "file", fileName: fileName, mimeType: mimeType)
            for (key, value) in params {
                data.append(value.data(using: .utf8)!, withName: key)
            }
        }, to: EndpointURL.messagecontent.url, method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            LOG("\n--> FILE NAME = \(fileName))\n\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func messageContent(params: [String: String], completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        let url = EndpointURL.messagecontent.url
        sessionManager.request(url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(params) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func categoryList(_ completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.categoryList.url, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func product_listing(params: Parameters, _ completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.product_listing.url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addProductShow(params: Parameters,img1: UIImage? ,img2: UIImage?, img3: UIImage?, _ completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        AF.upload(multipartFormData: { (data) in
            if img1 != nil{
                data.append(img1!.jpegData(compressionQuality: 0.7)!, withName: "img1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if img2 != nil{
                data.append(img2!.jpegData(compressionQuality: 0.7)!, withName: "img2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if img3 != nil{
                data.append(img3!.jpegData(compressionQuality: 0.7)!, withName: "img3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            for (key, value) in params {
                if let resu = value as? String{
                    
                    data.append(resu.data(using: .utf8)!, withName: key)
                }
            }
        }, to: EndpointURL.addProduct.url, method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            LOG("URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func buyProduct(params: Parameters, completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        let url = EndpointURL.buyProduct.url
        sessionManager.request(url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(params) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func myproducts(params: Parameters, _ completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.myProduct.url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func InquiryReceived(params: Parameters, _ completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.inquiry_received.url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    func deleteProduct(params: Parameters, completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        let url = EndpointURL.deleteProduct.url
        sessionManager.request(url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(params) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func editProduct(params: Parameters,img1: UIImage? ,img2: UIImage?, img3: UIImage?, _ completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        AF.upload(multipartFormData: { (data) in
            if img1 != nil{
                data.append(img1!.jpegData(compressionQuality: 0.7)!, withName: "img1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if img2 != nil{
                data.append(img2!.jpegData(compressionQuality: 0.7)!, withName: "img2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if img3 != nil{
                data.append(img3!.jpegData(compressionQuality: 0.7)!, withName: "img3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            for (key, value) in params {
                if let resu = value as? String{
                    
                    data.append(resu.data(using: .utf8)!, withName: key)
                }
            }
        }, to: EndpointURL.editProduct.url, method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            LOG("URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func updatesoldstatus(params: Parameters, completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        let url = EndpointURL.updatesoldstatus.url
        sessionManager.request(url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(params) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    
    func fetchRadomUser(for userId: String, completion: @escaping (_ list: [RadomUser], _ error: ErrorModel?) -> Void) {
        let url = EndpointURL.radomUser(userId).url
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let datas = value as? [NSDictionary] else {
                    return completion([], ErrorManager.processError())
                }
                
                
                completion(datas.compactMap({RadomUser.init(dic: $0)}), nil)
                
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func banner_image(params: Parameters,img1: UIImage?, _ completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        AF.upload(multipartFormData: { (data) in
            if img1 != nil{
                data.append(img1!.jpegData(compressionQuality: 0.7)!, withName: "banner_image", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in params {
                if let resu = value as? String{
                    
                    data.append(resu.data(using: .utf8)!, withName: key)
                }
            }
        }, to: EndpointURL.upload_banner.url, method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            LOG("URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    func currentcountry(complete:@escaping (_ success: Bool?, _ currentCountry: (String, String)?) ->Void)
    {
        
        AF.request(EndpointURL.currentcountry.url, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary, let country = val.value(forKey: "currentcountry") as? String
                    {
                        if let currentid = val.value(forKey: "currentid") as? Int {
                            complete(true, (country, String(currentid)))
                        } else if let currentid = val.value(forKey: "currentid") as? String {
                            complete(true, (country, currentid))
                        } else {
                            complete(true, (country, ""))
                        }
                        
                    }
                    else{
                        complete(false, nil)
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
        }
    }
    
    func getStates(countryId: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        AF.request(EndpointURL.state(countryId).url, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? [NSDictionary]
                    {
                        complete(true,  val)
                    }
                    else{
                        complete(false, nil)
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
        }
    }
    
    
    func updateNotifications(params: Parameters, completion: @escaping (_ success: Bool,  _ error: String?) -> Void) {
        let url = EndpointURL.updateNotification.url
        sessionManager.request(url, method: .post, parameters: params).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n-->\(params) STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(false, response.error?.localizedDescription)
                }
                if let Status = data.value(forKey: "Status") as? Bool, Status == true {
                   
                    return completion(true, nil)
                }
                return completion(false, data.value(forKey: "Message") as? String ?? "Something went wrong.")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    
    func appMenus(completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        sessionManager.request(EndpointURL.appmenus.url, method: .get, parameters: nil).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary] else {
                    completion(nil, nil)
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func resgiterAccountSupperApp(_ para: Parameters?, completion: @escaping (_ user: NSDictionary?, _ error: ErrorModel?) -> Void) {
        sessionManager.request(URL.init(string: API_SUPER_APP + "signup.php")!, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, ErrorManager.processError())
                }
                return completion(data, ErrorManager.processError())
            case .failure(let error):
                completion(nil, ErrorManager.processError(error: error))
            }
        }
    }
    
    func logInAccountSuperApp(_ para: Parameters?, completion: @escaping (_ user: NSDictionary?, _ error: ErrorModel?) -> Void) {
        sessionManager.request(URL.init(string: API_SUPER_APP + "login.php")!, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(nil, ErrorManager.processError())
                }
                return completion(data, ErrorManager.processError())
            case .failure(let error):
                completion(nil, ErrorManager.processError(error: error))
            }
        }
    }
    
    func myAPps(completion: @escaping (_ arrs: [NSDictionary]?, _ error: String?) -> Void) {
        let param = ["uid" :  UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String ?? ""]
        sessionManager.request(URL.init(string: API_SUPER_APP + "myapp.php")!, method: .post, parameters: param).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    completion(nil, nil)
                    return
                }
                let result = data.object(forKey: "data") as? [NSDictionary] ?? [NSDictionary]()
                completion(result, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    
    func deleteMyApp(_ id: String, completion: @escaping (_ arrs: NSDictionary?, _ error: String?) -> Void) {
        let param = ["id" :  id]
        sessionManager.request(URL.init(string: API_SUPER_APP + "/delete_app.php")!, method: .post, parameters: param).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n-->\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    completion(nil, nil)
                    return
                }
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func forgotpasswordSuper(_ email: String, _ completion: @escaping (_ error: String?) -> Void) {
        let para: Parameters = ["email": email]
        sessionManager.request(URL.init(string: API_SUPER_APP + "/forget_password.php")!, method: .post, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(response.error?.localizedDescription)
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(data.value(forKey: "Message") as? String)
                }
                completion(data.value(forKey: "Message") as? String)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func fetchUserMessageSupperApps(_ userId: String, _ completion: @escaping (_ results: [MessageDashboard]) -> Void) {
        let para: Parameters = ["sid": userId]
        sessionManager.request(URL.init(string: API_SUPER_APP + "/messages.php")!, parameters: para).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> PARA = \(para as Any)\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? [NSDictionary], !data.isEmpty else {
                    return completion([])
                }
                completion(data.compactMap({MessageDashboard.init(dic: $0)}))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func getMessageSuperAppsByUser(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        //sid=515&rid=428
        guard let user = UserDefaults.standard.value(forKey: USER_ID_SUPER_APP) as? String else{
            complete(false, nil)
            return
        }
        print("url--->",API_SUPER_APP + "msglist.php?sid=\(user)&rid=\(id)")
        sessionManager.request(URL.init(string: API_SUPER_APP + "msglist.php?sid=\(user)&rid=\(id)")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "Data") as? [NSDictionary])
                    }
                    else{
                        complete(false, nil)
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func addMSGSuperApp(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        print(API_SUPER_APP + "addmsg.php")
        sessionManager.request(URL.init(string: API_SUPER_APP + "addmsg.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                    {
                        if status {
                            
                            complete(true,  val.object(forKey: "Message") as? String ?? "")
                        }
                        else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
        }
    }
    
    func addMessageImageSuperApps(image1: UIImage?, param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            if let image1 = image1{
                multipartFormData.append(image1.jpegData(compressionQuality: 0.8)!, withName: "media", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
            
            
        }, to: API_SUPER_APP + "addmsg.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                {
                    if status {
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "Message") as? String ?? "")
                    }
                }
                else{
                    complete(false, response.error?.localizedDescription)
                }
                
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
    }
    
    func addMessageVideo(data: Data?, _ fileExtension: String, param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            if let data = data{
                multipartFormData.append(data, withName: "media", fileName: "uploaded_video." + fileExtension, mimeType: "video/\(fileExtension)")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
            
        }, to: API_SUPER_APP + "addmsg.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                {
                    if status {
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "Message") as? String ?? "")
                    }
                }
                else{
                    complete(false, response.error?.localizedDescription)
                }
                
                
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
    }
    
    func fetchNotificationSuperApp(for userId: String, completion: @escaping (_ list: [NotificationObject], _ error: ErrorModel?) -> Void) {
        let url = API_SUPER_APP + "push_notifications.php?id=\(userId)"
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion([], ErrorManager.processError())
                }
                
                guard let notification = data.arrayDictionary(forKey: "Data") else {
                    return completion([], ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
                }
                completion(notification.compactMap({NotificationObject.init(dic: $0)}), nil)
                
            case .failure(let error):
                completion([], ErrorManager.processError(error: error))
            }
        }
    }
    
    func makeNotificationAsSeenSuperApp(id: String, completion: @escaping (_ error: ErrorModel?) -> Void) {
        let url = API_SUPER_APP + "seen.php?id=\(id)"
        sessionManager.request(url).responseJSON { (response) in
            LOG("\n--> URL = \(String(describing: response.request?.url))\n--> STATUS CODE = \(String(describing: response.response?.statusCode))\n--> Response = \(response)")
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary else {
                    return completion(ErrorManager.processError())
                }
                if let status = data.value(forKey: "Status") as? Bool, status == true {
                    return completion(nil)
                }
                completion(ErrorManager.processError(errorMsg: data.value(forKey: "Message") as? String))
            case .failure(let error):
                completion(ErrorManager.processError(error: error))
            }
        }
    }
    
    func updateTokenSuperApp(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        sessionManager.request(URL.init(string: API_SUPER_APP + "update_imei.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                    {
                        if status {
                            
                            complete(true,  val.object(forKey: "Message") as? String ?? "")
                        }
                        else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
        }
    }
}
