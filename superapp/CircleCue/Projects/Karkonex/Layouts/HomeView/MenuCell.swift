//
//  MenuCell.swift
//  Karkonex
//
//  Created by QTS Coder on 16/04/2024.
//

import SwiftUI

struct MenuCell: View {
    var name: String
    var body: some View {
        HStack {
           Image("ic_home")
                .resizable()
               .frame(width: 20.0, height: 20.0)
               .aspectRatio(contentMode: .fit)
          
           Text(name)
                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 17.0))
                .multilineTextAlignment(.leading)
               .padding(.all)
       }
    }
}

#Preview {
    MenuCell(name: "")
}
