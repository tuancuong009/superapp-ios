//
//  FirebaseImageHelper.swift
//  SuperApp
//
//  Created by QTS Coder on 23/9/25.
//


import UIKit
import FirebaseDatabase

class FirebaseImageHelper {
    
    // MARK: - Convert UIImage <-> Base64
    
    static func imageToBase64(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    static func base64ToImage(_ base64: String) -> UIImage? {
        if let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
}
extension UIImage {
    func resizeTo200() -> UIImage? {
        let targetSize = CGSize(width: 200, height: 200)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension String {
    func initials() -> String {
        return self
            .split(separator: " ")          // tách theo dấu cách
            .map { String($0.prefix(1)).uppercased() } // lấy ký tự đầu tiên, viết hoa
            .joined()
    }
}


extension UIColor {
    static func randomNotWhite() -> UIColor {
        var color: UIColor
        repeat {
            color = UIColor(
                red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1.0
            )
        } while color.isTooLight() // tránh trắng hoặc gần trắng
        return color
    }
    
    private func isTooLight() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Tính brightness (0 = đen, 1 = trắng)
        let brightness = (red + green + blue) / 3.0
        return brightness > 0.85  // nếu quá sáng thì coi như trắng
    }
}
