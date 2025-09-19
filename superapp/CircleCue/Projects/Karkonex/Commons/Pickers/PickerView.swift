//
//  PickerView.swift
//  Karkonex
//
//  Created by QTS Coder on 21/10/24.
//

import SwiftUI

struct PickerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: NSDictionary
    let items: [NSDictionary]
    let title: String

    var body: some View {
        VStack {
            header

            Picker(title, selection: $selection) {
                ForEach(items, id: \.self) { item in
                    if let name = item.object(forKey: "country_name") as? String{
                        Text(name).tag(item.object(forKey: "id") as? String ?? "").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 20))
                    }
                    else{
                        Text(item.object(forKey: "name") as? String ?? "").tag(item.object(forKey: "id") as? String ?? "").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 20))
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle()) // Use wheel picker style for a more classic picker experience
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
                print("arrr--->",items)
                if let id = selection.object(forKey: "id") as? String{
                    print(id)
                }
                else{
                    if items.count > 0 {
                        selection = items[0]
                    }
                }
               
            }
        }
    }
}
extension PickerView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Text(title).font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22))
                    .foregroundColor(Color.black)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
