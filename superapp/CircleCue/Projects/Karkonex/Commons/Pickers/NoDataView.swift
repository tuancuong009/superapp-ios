//
//  NoDataView.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI

struct NoDataView: View {
    let message: String
    var body: some View {
        VStack{
            Spacer()
            Text(message).font(.custom(FONT_NAME.FUTURA_REGULAR, size: 17))
                .foregroundColor(Color.gray)
            Spacer()
        }
    }
}

#Preview {
    NoDataView(message: "No result")
}
