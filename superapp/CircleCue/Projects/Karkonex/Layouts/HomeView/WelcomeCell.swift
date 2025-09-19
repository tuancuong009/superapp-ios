//
//  WelcomeCell.swift
//  Karkonex
//
//  Created by QTS Coder on 12/11/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct WelcomeCell: View {
    let index: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack{
                Image(uiImage: UIImage.init(named: "car\(index)")!).resizable().fitToAspectRatio(1.67)
                
                
                HStack{
                    Text(self.titleCell()).lineLimit(1)
                        .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 14))
                        .foregroundColor(.init(hex: "#1D1D1D"))
                    Spacer()
                }
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 2, trailing: 10))
                HStack{
                    Text(self.addressCell()).lineLimit(1)
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 11))
                        .foregroundColor(.init(hex: "#870B0B"))
                    Spacer()
                    
                    Text(self.priceCell()).lineLimit(1)
                        .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 10))
                        .foregroundColor(.init(hex: "#870B0B"))
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                Spacer(minLength: 5)
            }
            .background(Color.init(hex: "F3F3F3"))
            .cornerRadius(10)
            
        }
       
       
     
    }
    
    private func titleCell()-> String{
        switch index {
        case 0:
            return "Chevrolet Camaro"
        case 1:
            return "Toyota Prius"
        case 2:
            return "Lexus"
        case 3:
            return "Hyundai Elantra"
        case 4:
            return "Audi"
        case 5:
            return "Toyota Sienna"
        case 6:
            return "Grand Gherokee 2016"
        case 7:
            return "Volkswagen"
        default:
            return ""
        }
    }
    
    private func addressCell()-> String{
        switch index {
        case 0:
            return "Fairfax, VA"
        case 1:
            return "San francisco, CA"
        case 2:
            return "Philpadephlia, PA"
        case 3:
            return "Washington, DC"
        case 4:
            return "Boston, MA"
        case 5:
            return "New York, NY"
        case 6:
            return "Houston, TX"
        case 7:
            return "Chicago, IL"
        default:
            return ""
        }
    }
    
    private func priceCell()-> String{
        switch index {
        case 0:
            return "$50 / Day"
        case 1:
            return "$4950 / Sale"
        case 2:
            return "$12,990 / Day"
        case 3:
            return "$14,500 / Sale"
        case 4:
            return "$40 / Day"
        case 5:
            return "$9000 / Sale"
        case 6:
            return "$50 / Day"
        case 7:
            return "$35 / Day"
        default:
            return ""
        }
    }
}

