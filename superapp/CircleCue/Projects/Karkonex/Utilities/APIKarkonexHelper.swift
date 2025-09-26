//


import UIKit
import Alamofire
class APIKarkonexHelper {
    static let shared = APIKarkonexHelper()
    private let auth_headerLogin: HTTPHeaders    = ["Content-Type": "application/json"]
    
    private var manager: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        manager = Session(configuration: configuration)
    }
    
    
    
    func loginUser(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "login_submit.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: val.object(forKey: "id") as? String ?? "")
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
    func getCountries(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        
        manager.request(URL.init(string: Config.shared.URL_SERVER + "countries.php")!, method: .get, parameters: nil)
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
        
        manager.request(URL.init(string: Config.shared.URL_SERVER + "state.php?id=\(countryId)")!, method: .get, parameters: nil)
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
    func registerSocial(param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "signup_social.php")!, method: .post, parameters: param)
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
                            AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: userId)
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
                            AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: userId)
                            complete(true, nil)
                        }
                        else{
                            complete(false, val.object(forKey: "Message") as? String ?? "")
                        }
                    }
                    else{
                        if let val = response.value as? NSDictionary, let id = val.object(forKey: "id") as? String
                        {
                            AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: id)
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
    func uploadPhoto(_ param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("Image--->",image)
        print("Param--->",param)
        let dateNameImg = Int(Date().timeIntervalSince1970)
        let nameImg = "\(dateNameImg).jpg"
        manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "img", fileName:nameImg, mimeType: "image/jpg")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }
                       , to: Config.shared.URL_SERVER + "register_submit.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        var userID = ""
                        if let id = val.object(forKey: "message") as? String{
                            userID = id
                        }
                        else if let id = val.object(forKey: "message") as? Int{
                            userID = "\(id)"
                        }
                        AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: userID)
                        complete(true,  nil)
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
                else if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? String
                {
                    if status == "1"{
                        var userID = ""
                        if let id = val.object(forKey: "message") as? String{
                            userID = id
                        }
                        else if let id = val.object(forKey: "message") as? Int{
                            userID = "\(id)"
                        }
                        AuthKaKonex.shared.setCredentials(accessToken: "", refreshToken: "", userId: userID)
                        complete(true,  nil)
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
                else{
                    complete(false, "Register fail")
                }
                
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
        
    }
    
    
    func myprofile(id: String, complete:@escaping (_ success: Bool?, _ dict: NSDictionary?) ->Void)
    {
        let param = ["id": id]
        manager.request(URL.init(string: Config.shared.URL_SERVER + "view_profile.php?id=\(id)")!, method: .post, parameters: param)
            .responseJSON { response in
                print("myprofile--->",response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        complete(true,  val.object(forKey: "data") as? NSDictionary)
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
    
    func contactUs(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print(param)
        print(Config.shared.URL_SERVER + "contact.php")
        manager.request(URL.init(string: Config.shared.URL_SERVER + "contact.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            
                            complete(true,  val.object(forKey: "message") as? String ?? "")
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
    
    func addCar(_ param: Parameters, _ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
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
        }
                       , to:  Config.shared.URL_SERVER + "add_car.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(response)
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
    
    func addMSGMedia(_ param: Parameters, _ image1: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        manager.upload(multipartFormData: { (multipartFormData) in
            if image1 != nil{
                
                multipartFormData.append(image1!.jpegData(compressionQuality: 0.8)!, withName: "media", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }
                       , to:  Config.shared.URL_SERVER + "addmsg.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(response)
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                {
                    if status {
                        complete(true, nil)
                    }
                    else{
                        complete(false, val.object(forKey: "Message") as? String ?? "")
                    }
                }
                
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
    }
    
    func addMSG(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",Config.shared.URL_SERVER)
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "addmsg.php")!, method: .post, parameters: param)
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
    
    func getMessages(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "messages.php" + "?sid=\(id)")!, method: .get, parameters: nil)
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
    
    func addBlock(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "addblock.php")!, method: .post, parameters: param)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "remove_block.php" + "?id=\(id)")!, method: .post, parameters: nil)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "block_list.php" + "?id=\(id)")!, method: .get, parameters: nil)
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
    
    
    func deleteMessage(_ id: String, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "deletemsg.php" + "?id=\(id)")!, method: .post, parameters: nil)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "msglist.php" + "?sid=\(AuthKaKonex.shared.getUserId())&rid=\(id)")!, method: .get, parameters: nil)
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
    
    func getNotifications(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "push_notifications.php" + "?id=\(id)")!, method: .get, parameters: nil)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "delete_notification.php" + "?id=\(id)")!, method: .post, parameters: nil)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "seen.php" + "?id=\(id)")!, method: .post, parameters: nil)
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
    
    func booking(_ param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("Image--->",image)
        print("Param--->",param)
        let dateNameImg = Int(Date().timeIntervalSince1970)
        let nameImg = "\(dateNameImg).jpg"
        manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "img", fileName:nameImg, mimeType: "image/jpg")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }
                       , to:  Config.shared.URL_SERVER + "booking.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(response)
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        complete(true,  val.object(forKey: "message") as? String ?? "")
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
                else if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? String
                {
                    if status == "1"{
                        complete(true,  val.object(forKey: "message") as? String ?? "")
                    }
                    else{
                        complete(false, val.object(forKey: "message") as? String ?? "")
                    }
                }
                else{
                    complete(false, "Fail")
                }
                
            case .failure(let error):
                print(error)
                complete(false, error.localizedDescription)
            }
        }
    }
    
    func getInquiryRecieved(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        let param = ["uid":id]
        manager.request(URL.init(string: Config.shared.URL_SERVER + "inquiry_listing.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        var values = [NSDictionary]()
                        if let datas = val.object(forKey: "data") as? [NSDictionary]{
                            for data in datas {
                                values.append(data.object(forKey: "car") as? NSDictionary ?? NSDictionary())
                            }
                        }
                        print("getInquiryRecieved--->",values.count)
                        complete(true,  values)
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
    
    func getInquirySent(_ id: String, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        let param = ["uid":id]
        manager.request(URL.init(string: Config.shared.URL_SERVER + "inquiry_listing2.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        var values = [NSDictionary]()
                        if let datas = val.object(forKey: "data") as? [NSDictionary]{
                            for data in datas {
                                values.append(data.object(forKey: "car") as? NSDictionary ?? NSDictionary())
                            }
                        }
                        print("datas--->",values.count)
                        complete(true,  values)
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
    
    func viewCar(id: String, uid: String, complete:@escaping (_ success: Bool?, _ dict: NSDictionary?) ->Void)
    {
        let param = ["id":id, "uid": uid]
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "view_car.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        if let data = val.object(forKey: "data") as? [NSDictionary], data.count > 0{
                            complete(true,  data[0].object(forKey: "car") as? NSDictionary ?? NSDictionary())
                        }
                        else{
                            complete(true,  nil)
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
    
    
    func myCards(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        let param = ["uid":AuthKaKonex.shared.getUserId()]
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "view_car.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    
                    if let val = response.value as? NSDictionary
                    {
                        var values = [NSDictionary]()
                        if let datas = val.object(forKey: "data") as? [NSDictionary]{
                            for data in datas {
                                values.append(data.object(forKey: "car") as? NSDictionary ?? NSDictionary())
                            }
                        }
                        print("datas--->",values.count)
                        complete(true,  values)
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
    
    func editCar(_ param: Parameters, _ image1: UIImage?, _ image2: UIImage?, _ image3: UIImage?, _ image4: UIImage?, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
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
        }
                       , to:  Config.shared.URL_SERVER + "edit_car.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(response)
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
    
    func deleteCar(id: String, complete:@escaping (_ success: Bool?, _ error: String?) ->Void)
    {
        let param = ["id":id]
        manager.request(URL.init(string: Config.shared.URL_SERVER + "delete_car.php")!, method: .post, parameters: param)
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
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func showcase(complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "showcase.php")!, method: .get, parameters: nil)
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
    
    
    func search(_ param: Parameters, complete:@escaping (_ success: Bool?, _ dict: [NSDictionary]?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "search.php")!, method: .get, parameters: param)
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
    
    
    func editProfile(_ param: Parameters, complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        print("url--->",Config.shared.URL_SERVER)
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "edit_profile.php")!, method: .post, parameters: param)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                    {
                        if status {
                            
                            complete(true,  val.object(forKey: "message") as? String ?? "")
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
    
    func editProfileAvatar(_ param: Parameters, _ image: UIImage, complete:@escaping (_ success: Bool?, _ errer: String?) ->Void)
    {
        print("Image--->",image)
        print("Param--->",param)
        let dateNameImg = Int(Date().timeIntervalSince1970)
        let nameImg = "\(dateNameImg).jpg"
        manager.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "img", fileName:nameImg, mimeType: "image/jpg")
            
            for (key, value) in param {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        }
                       , to:  Config.shared.URL_SERVER + "edit_profile.php", method: .post).uploadProgress(queue: .main, closure: { (progress) in
            print("Progress uploading = ", progress.fractionCompleted * 100)
        }).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                print(response)
                if let val = response.value as? NSDictionary, let status = val.object(forKey: "status") as? Bool
                {
                    if status {
                        
                        complete(true,  val.object(forKey: "message") as? String ?? "")
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
    
    func delete_inquiry(id: String, complete:@escaping (_ success: Bool?, _ error: String?) ->Void)
    {
        let param = ["id":id]
        print(param)
        manager.request(URL.init(string: Config.shared.URL_SERVER + "delete_inquiry.php")!, method: .post, parameters: param)
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
                case .failure(_):
                    complete(false, nil)
                }
            }
    }
    
    func deleteProfile(complete:@escaping (_ success: Bool?, _ erro: String?) ->Void)
    {
        manager.request(URL.init(string: Config.shared.URL_SERVER + "delete_account.php?id=\(AuthKaKonex.shared.getUserId())")!, method: .get, parameters: nil)
            .responseJSON { response in
                print(response)
                switch(response.result) {
                case .success(_):
                    if let val = response.value as? NSDictionary, let status = val.object(forKey: "Status") as? Bool
                    {
                        if status {
                            complete(true, nil)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "update_imei.php")!, method: .post, parameters: param)
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
        manager.request(URL.init(string: Config.shared.URL_SERVER + "forget_submit.php")!, method: .post, parameters: param)
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
