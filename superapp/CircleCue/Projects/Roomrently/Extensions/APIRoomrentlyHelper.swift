//
//  APIRoomrentlyHelper.swift

import UIKit
import Alamofire
class APIRoomrentlyHelper {
    static let shared = APIRoomrentlyHelper()
    private let auth_headerLogin: HTTPHeaders    = ["Content-Type": "application/json"]
    private var manager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        manager = Session(configuration: configuration)
    }
    
    
    func registerUserAvatar(_ param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("Param--->",param)
        print("url-->",API_URL.URL_SERVER + "register_submit.php")
        manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.8)!, withName: "img", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        },to: API_URL.URL_SERVER + "register_submit.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        var uid = ""
                        if let id = val.object(forKey: "message") as? Int{
                            uid = "\(id)"
                        }
                        else if let id = val.object(forKey: "message") as? String{
                            uid = id
                        }
                        UserDefaults.standard.setValue(uid, forKey: USER_ID_RR)
                        UserDefaults.standard.synchronize()
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
        
    }
    
    func loginUser(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "login_submit.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "login_submit.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            var uid = ""
                            if let id = val.object(forKey: "id") as? Int{
                                uid = "\(id)"
                            }
                            else if let id = val.object(forKey: "id") as? String{
                                uid = id
                            }
                            print("uid---->",uid)
                            UserDefaults.standard.setValue(uid, forKey: USER_ID_RR)
                            UserDefaults.standard.synchronize()
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    func registerSocial(param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "signup_social.php")!, method: .post, parameters: param)
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
                            UserDefaults.standard.set(userId, forKey: USER_ID_RR)
                            UserDefaults.standard.synchronize()
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                    }
                    else if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            var userId = ""
                            
                            if let data = val.object(forKey: "data") as? NSDictionary{
                                if let Data = data.object(forKey: "id") as? Int{
                                    userId = "\(Data)"
                                }
                                else if let Data = data.object(forKey: "id") as? String{
                                    userId = Data
                                }
                            }
                            UserDefaults.standard.set(userId, forKey: USER_ID_RR)
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
                            UserDefaults.standard.set(id, forKey: USER_ID_RR)
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
    
    func getMyProfile(complete:@escaping (_ success: Bool?, _ dict: NSDictionary?) ->Void)
    {
        let param: Parameters = ["id": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
        print("url--->",API_URL.URL_SERVER + "profile.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "profile.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            
                            complete(true, val.object(forKey: "data") as? NSDictionary)
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, nil)
                }
            }
    }
    
    func updateProfileAvatar(_ param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.8)!, withName: "img", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        },to: API_URL.URL_SERVER + "profile_update.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
    }
    
    func AddlistApi(_ param: Parameters, _ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            if image1 != nil{
                
                multipartFormData.append(image1!.jpegData(compressionQuality: 0.8)!, withName: "limg1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if image2 != nil{
                multipartFormData.append(image2!.jpegData(compressionQuality: 0.8)!, withName: "limg2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
            }
            if image3 != nil{
                multipartFormData.append(image3!.jpegData(compressionQuality: 0.8)!, withName: "limg3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
            }
            if image4 != nil{
                
                multipartFormData.append(image4!.jpegData(compressionQuality: 0.8)!, withName: "limg4", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        },to: API_URL.URL_SERVER + "add_property.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
        
        
    }
    
    
    func editlistApi(_ param: Parameters, _ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            
            if image1 != nil{
                
                multipartFormData.append(image1!.jpegData(compressionQuality: 0.8)!, withName: "limg1", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            if image2 != nil{
                multipartFormData.append(image2!.jpegData(compressionQuality: 0.8)!, withName: "limg2", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
            }
            if image3 != nil{
                multipartFormData.append(image3!.jpegData(compressionQuality: 0.8)!, withName: "limg3", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
                
            }
            if image4 != nil{
                
                multipartFormData.append(image4!.jpegData(compressionQuality: 0.8)!, withName: "limg4", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }, to: API_URL.URL_SERVER + "edit_property.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
        
    }
    
    func updateProfile(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "profile_update.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "profile_update.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    func deleteProfile(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "deleteprofile.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "deleteprofile.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    
    func myProperty(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "my_property.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "my_property.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func deleteProperty(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "delete_property.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "delete_property.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    
    func addContact(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "add_contact.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "add_contact.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    
    
    func addInquiry(_ param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "add_inquiry.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "add_inquiry.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
        
    }
    
    func addInquiryBuy(_ param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "add_inquiry.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "add_inquiry.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
        
    }
    
    
    func addWant(_ param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "add_wanted.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "add_wanted.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
        
    }
    
    func editWanted(_ param: Parameters, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "edit_wanted.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "edit_wanted.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "message") as? String ?? "")
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
        
    }
    func myInquirySent(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "my_inquiry_sent.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "my_inquiry_sent.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    func my_inquiry_rcvd(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "my_inquiry_rcvd.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "my_inquiry_rcvd.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func property(_ page: Int, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?,_ totalpage: Int) ->Void)
    {
        let page = ["page": page]
        print("url--->",API_URL.URL_SERVER + "property.php")
        print("Param --->", page)
        manager.request(URL.init(string: API_URL.URL_SERVER + "property.php")!, method: .post, parameters: page)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary], val.object(forKey: "totalpage") as? Int ?? 0)
                        }
                        else{
                            complete(false, nil, 0)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil, 0)
                }
            }
    }
    
    func myWanted(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "my_wanted.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "my_wanted.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    
    func getStates(complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "states.php")
        manager.request(URL.init(string: API_URL.URL_SERVER + "states.php")!, method: .post, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func search(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?, _ totalpage: Int) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "property.php")
        manager.request(URL.init(string: API_URL.URL_SERVER + "property.php")!, method: .post, parameters: param)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary], val.object(forKey: "totalpage") as? Int ?? 0)
                        }
                        else{
                            complete(false, nil, 0)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil, 0)
                }
            }
    }
    
    func wanted(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?, _ totalpage: Int) ->Void)
    {
        print("wanted--->",param)
        print("url--->",API_URL.URL_SERVER + "wanted.php")
        manager.request(URL.init(string: API_URL.URL_SERVER + "wanted.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary], val.object(forKey: "totalpage") as? Int ?? 0)
                        }
                        else{
                            complete(false, nil, 0)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil, 0)
                }
            }
    }
    func resetPassword(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "resetpassword.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "resetpassword.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary
                    {
                        complete(val.object(forKey: "status") as? Bool ?? false, val.object(forKey: "message") as? String ?? "")
                    }
                    break
                case .failure(let error):
                    complete(false, error.localizedDescription)
                }
            }
    }
    
    func getMessages(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_MESSAGES + "?sid=\(id)")
        manager.request(URL.init(string: API_URL.URL_MESSAGES + "?sid=\(id)")!, method: .get, parameters: nil)
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
    
    func deleteMessage(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: API_URL.URL_DELETE_MESSAGES + "?id=\(id)")!, method: .post, parameters: nil)
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
    
    func addMSG(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_ADDMESSAGE)
        print(param)
        manager.request(URL.init(string: API_URL.URL_ADDMESSAGE)!, method: .post, parameters: param)
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
    
    func getMessageChatByUser(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        //sid=515&rid=428
        guard let user = UserDefaults.standard.value(forKey: USER_ID_RR) as? String else{
            complete(false, nil)
            return
        }
        print("url--->",API_URL.URL_CHAT_MESSAGES + "?sid=\(user)&rid=\(id)")
        manager.request(URL.init(string: API_URL.URL_CHAT_MESSAGES + "?sid=\(user)&rid=\(id)")!, method: .get, parameters: nil)
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
    
    func updateToken(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",API_URL.URL_UPDATE_TOKEN)
        print(param)
        manager.request(URL.init(string: API_URL.URL_UPDATE_TOKEN)!, method: .post, parameters: param)
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
        print("url--->",API_URL.URL_GETNOTIFICATIONS + "?id=\(id)")
        manager.request(URL.init(string: API_URL.URL_GETNOTIFICATIONS + "?id=\(id)")!, method: .get, parameters: nil)
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
        print("url--->",API_URL.URL_DELETE_NOTIFICATION)
        manager.request(URL.init(string: API_URL.URL_DELETE_NOTIFICATION + "?id=\(id)")!, method: .post, parameters: nil)
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
        print("url--->",API_URL.URL_SEEN_NOTIFICATIONS)
        manager.request(URL.init(string: API_URL.URL_SEEN_NOTIFICATIONS + "?id=\(id)")!, method: .post, parameters: nil)
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
    
    func getProfileUser(_ id: String, complete:@escaping (_ success: Bool?, _ dict: NSDictionary?) ->Void)
    {
        let param: Parameters = ["id": id]
        print("url--->",API_URL.URL_SERVER + "profile.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "profile.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            
                            complete(true, val.object(forKey: "data") as? NSDictionary)
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(let error):
                    complete(false, nil)
                }
            }
    }
    
    func myPropertyUser(_ param: Parameters, complete:@escaping (_ success: Bool?, _ arrs: [NSDictionary]?) ->Void)
    {
        print("url--->",API_URL.URL_SERVER + "my_property.php")
        print(param)
        manager.request(URL.init(string: API_URL.URL_SERVER + "my_property.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            complete(true, val.object(forKey: "data") as? [NSDictionary])
                        }
                        else{
                            complete(false, nil)
                        }
                    }
                    break
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func deleteWant(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        let param = ["id": id]
        manager.request(URL.init(string: API_URL.URL_SERVER + "delete_wanted.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
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
