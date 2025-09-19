//
//  APIHelper.swift
//  👉👉👉👉👉👉👉👉👉 🍎🍎 Practice 🍎🍎 👈👈👈👈👈👈👈👈👈
//
//  Created by QTS Coder on 29/10/2018.
//  Copyright © 2018 QTS Coder. All rights reserved.
//

import UIKit
import Alamofire
class APIHelper {
    static let shared = APIHelper()
    private let auth_headerLogin: HTTPHeaders    = ["Content-Type": "application/json"]
    
    private var manager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        manager = Session(configuration: configuration)
    }
    
    func getCountries(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "countries.php")!, method: .get, parameters: nil)
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
    
    func currentcountry(complete:@escaping (_ success: Bool?, _ currentCountry: (String, String)?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "currentcountry.php")!, method: .get, parameters: nil)
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
    
    
    func getGoals(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "goals.php")!, method: .get, parameters: nil)
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
    
    func getStates(countryId: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "state.php?id=\(countryId)")!, method: .get, parameters: nil)
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
    
    func getReligions(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "religion.php")!, method: .get, parameters: nil)
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
    
    func registerUserAvatar(image1: UIImage?, image2: UIImage?, image3: UIImage?, param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("PARAM000--->",param)
        AF.upload(multipartFormData: { (multipartFormData) in
            if let image1 = image1{
                multipartFormData.append(image1.jpegData(compressionQuality: 0.8)!, withName: "img1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
           
            if let image2 = image2{
                multipartFormData.append(image2.jpegData(compressionQuality: 0.8)!, withName: "img2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if let image3 = image3{
                multipartFormData.append(image3.jpegData(compressionQuality: 0.8)!, withName: "img3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }, to: URL_API.SERVER + "signup_submit.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                {
                    if status {
                        var userId = ""
                        
                        if let Data = val.object(forKey: "Data") as? Int{
                            userId = "\(Data)"
                        }
                        else if let Data = val.object(forKey: "Data") as? String{
                            userId = Data
                        }
                        UserDefaults.standard.set(userId, forKey: USER_ID)
                        UserDefaults.standard.synchronize()
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
    
    func registerSocial(param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "signup_social.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    print(response)
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                    {
                        if status {
                            var userId = ""
                            
                            if let Data = val.object(forKey: "Data") as? Int{
                                userId = "\(Data)"
                            }
                            else if let Data = val.object(forKey: "Data") as? String{
                                userId = Data
                            }
                            UserDefaults.standard.set(userId, forKey: USER_ID)
                            UserDefaults.standard.synchronize()
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                    }
                    else{
                        if let val = response.value as? NSDictionary, let id = val.object(forKey: "id") as? String
                        {
                            UserDefaults.standard.set(id, forKey: USER_ID)
                            UserDefaults.standard.synchronize()
                            complete(true, nil)
                        }else{
                            complete(false, response.error?.localizedDescription)
                        }
                    }
                    
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
        }
    }
    
    func updatePhotos(image1: UIImage?, image2: UIImage?, image3: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        let param = ["id":UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""]
        AF.upload(multipartFormData: { (multipartFormData) in
            if let image1 = image1{
                multipartFormData.append(image1.jpegData(compressionQuality: 0.8)!, withName: "img1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
           
            if let image2 = image2{
                multipartFormData.append(image2.jpegData(compressionQuality: 0.8)!, withName: "img2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if let image3 = image3{
                multipartFormData.append(image3.jpegData(compressionQuality: 0.8)!, withName: "img3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }, to: URL_API.SERVER + "update_photos.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
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
    
    func updatePhotosByComplete(id: String, image1: UIImage?, image2: UIImage?, image3: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        let param = ["id":id]
        manager.upload(multipartFormData: { (multipartFormData) in
            if let image1 = image1{
                multipartFormData.append(image1.jpegData(compressionQuality: 0.8)!, withName: "img1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
           
            if let image2 = image2{
                multipartFormData.append(image2.jpegData(compressionQuality: 0.8)!, withName: "img2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if let image3 = image3{
                multipartFormData.append(image3.jpegData(compressionQuality: 0.8)!, withName: "img3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }, to: URL_API.SERVER + "update_photos.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
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
    
    func loginUser(param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "login.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary
                    {
                        if let data = val.object(forKey: "data") as? NSDictionary{
                            var userId = ""
                            
                            if let Data = data.object(forKey: "id") as? Int{
                                userId = "\(Data)"
                            }
                            else if let Data = data.object(forKey: "id") as? String{
                                userId = Data
                            }
                            UserDefaults.standard.set(userId, forKey: USER_ID)
                            UserDefaults.standard.synchronize()
                            complete(true, nil)
                        }else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                        
                    }else{
                        complete(false, response.error?.localizedDescription)
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
        }
    }
    
    
    func searchPefrance(param: Parameters, complete:@escaping (_ success: Bool?, _ error:String?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "search_pefrance.php")!, method: .post, parameters: param)
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
                case .failure(_):
                    complete(false, nil)
                }
        }
    }
    
    func myprofile(id: String, complete:@escaping (_ success: Bool?, _ dict: NSDictionary?) ->Void)
    {
        print(URL_API.SERVER + "profile.php?id=\(id)")
        manager.request(URL.init(string: URL_API.SERVER + "profile.php?id=\(id)")!, method: .get, parameters: nil)
            .responseJSON { response in
                print("myprofile--->",response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary
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
    
    func liekd(id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "likes.php?id=\(id)")!, method: .get, parameters: nil)
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
    
    func likedMe(id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "likedme.php?id=\(id)")!, method: .get, parameters: nil)
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
    func getMaybes(id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: URL_API.SERVER + "maybe.php?id=\(id)")!, method: .get, parameters: nil)
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
    func getMessages(id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        print("Get Messages--->",URL_API.SERVER + "messages.php?sid=\(id)")
        manager.request(URL.init(string: URL_API.SERVER + "messages.php?sid=\(id)")!, method: .get, parameters: nil)
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
    
    func getMessageChatByUser(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        print("msglist--->",URL_API.SERVER + "msglist.php?sid=\(userID)&rid=\(id)")
        manager.request(URL.init(string: URL_API.SERVER + "msglist.php?sid=\(userID)&rid=\(id)")!, method: .get, parameters: nil)
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
    
    func addMSG(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        print(URL_API.SERVER + "addmsg.php")
        manager.request(URL.init(string: URL_API.SERVER + "addmsg.php")!, method: .post, parameters: param)
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
    
    func addMessageImage(image1: UIImage?, param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            if let image1 = image1{
                multipartFormData.append(image1.jpegData(compressionQuality: 0.8)!, withName: "media", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
            
            
        }, to: URL_API.SERVER + "addmsg.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
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
        manager.upload(multipartFormData: { (multipartFormData) in
            if let data = data{
                multipartFormData.append(data, withName: "media", fileName: "uploaded_video." + fileExtension, mimeType: "video/\(fileExtension)")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
            
        }, to: URL_API.SERVER + "addmsg.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
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
    
    
    func deleteMessage(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "deletemsg.php?id=\(id)")!, method: .post, parameters: nil)
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
    
    func forgotpassword(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "forget_submit.php")!, method: .post, parameters: param)
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
    
    func getNotifications(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "push_notifications.php?id=\(id)")!, method: .get, parameters: nil)
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
    
    func deleteNotification(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "deletemsg.php?id=\(id)")!, method: .post, parameters: nil)
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
    
    func seenNotification(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "seen.php?id=\(id)")!, method: .post, parameters: nil)
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
    
    func updateToken(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "update_imei.php")!, method: .post, parameters: param)
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
    
    
    func signuppush(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "signuppush.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print("signuppush---->",response)
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
    
    func deleteUser(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "delete_user.php")!, method: .post, parameters: param)
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
    func contactUs(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: URL_API.SERVER + "csubmit.php")!, method: .post, parameters: param)
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
    
    func contactUsFile(data: Data?, nameFile: String, extesionFile: String, param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            if let data = data{
                multipartFormData.append(data, withName: "file", fileName: nameFile, mimeType:extesionFile)
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
            
        }, to: URL_API.SERVER + "csubmit.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
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
    
    
    func search_listing(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "search_listing.php?id=\(id)")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "Message") as? [NSDictionary])
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
    
    func likedYes(id: String, id2: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "addlikes.php?id=\(id)&id2=\(id2)&type=1")!, method: .get, parameters: nil)
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
    func rejectNo(id: String, id2: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "addlikes.php?id=\(id)&id2=\(id2)&type=2")!, method: .get, parameters: nil)
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
    func addMaybe(id: String, id2: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "addlikes.php?id=\(id)&id2=\(id2)&type=3")!, method: .get, parameters: nil)
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
    func profileUpdate(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        print("url--->",URL_API.SERVER + "profile_update.php")
        manager.request(URL.init(string: URL_API.SERVER + "profile_update.php")!, method: .post, parameters: param)
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
    
    func addBlock(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "addblock.php")!, method: .post, parameters: param)
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
    
    func removeBlock(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
 
        manager.request(URL.init(string: URL_API.SERVER + "remove_block.php?id=\(id)")!, method: .post, parameters: nil)
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
    
    func getListBlock(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER  + "block_list.php?id=\(id)")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "data") as? [NSDictionary])
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
    
    func showcase(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        print("URL--->",URL_API.SERVER + "showcase.php?id=\(userID)")
        manager.request(URL.init(string: URL_API.SERVER + "showcase.php?id=\(userID)")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "Message") as? [NSDictionary])
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
    
    func onboarding(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: URL_API.SERVER + "userlist.php")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                   
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "Message") as? [NSDictionary])
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
    
    func deletePic(_ pic: String, complete:@escaping (_ success: Bool?, _ error: String?) ->Void)
    {
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        let param = ["id": userID, "pic": pic]
        manager.request(URL.init(string: URL_API.SERVER  + "deletepic.php")!, method: .post, parameters: param)
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
