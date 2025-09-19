//
//  DatePicker.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI

struct DatePickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var date: Date
   
    var body: some View {
        VStack {
            header
            DatePicker(selection: $date, displayedComponents: .date) {
                
            }.datePickerStyle(.wheel)
                .labelsHidden()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            Spacer()
            Button (
                action: {
                    presentationMode.wrappedValue.dismiss()

                },
                label: {
                    Text("DONE")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                })
            .buttonStyle(PikcerButton()).padding(.bottom, 0)
            .padding()
            .onAppear {
               
            }
        }
    }
}
extension DatePickerView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Text("Date").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22))
                    .foregroundColor(Color.black)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
