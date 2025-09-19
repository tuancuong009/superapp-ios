//
//  MyInquiryView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//
import SwiftUI

struct MyInquiryView: View {
    @State private var indexSegemt = 0
    @StateObject var inquiryModel = InquiryModel()
    var body: some View {
        VStack {
            HStack{
                Picker("", selection: $indexSegemt) {
                    Text("Recieved").tag(0)
                    Text("Sent").tag(1)
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            if indexSegemt == 0 {
                if inquiryModel.apiStateReceiver == .loading{
                    HStack{
                        ProgressView {
                            
                        }
                    }
                    Spacer()
                }
                else{
                    if inquiryModel.resultReceivers.count == 0 {
                        NoDataView(message: "No Recieved")
                        Spacer()
                    }
                    else{
                        ScrollView{
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 0) {
                                ForEach(0...inquiryModel.resultReceivers.count-1, id: \.self) { i in
                                    NavigationLink(destination: DetailView(carId: inquiryModel.resultReceivers[i].object(forKey: "carid") as? String ?? "", uid: inquiryModel.resultReceivers[i].object(forKey: "uid") as? String ?? "")) {
                                        MyInquiryCell(carModel: CarObj(dict: inquiryModel.resultReceivers[i]), isReceived: true, deleteSuccess: self.deleteSuccess )
                                   }
                                   .isDetailLink(false)
                                   .buttonStyle(ButtonNormal())
                                }

                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        Spacer()
                    }
                   
                   
                }
                
            }
            else{
                if inquiryModel.apiState == .loading{
                    HStack{
                        ProgressView {
                            
                        }
                    }
                    Spacer()
                }
                else{
                    if inquiryModel.resultSents.count == 0 {
                        NoDataView(message: "No Sent")
                        Spacer()
                    }
                    else{
                        ScrollView{
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 0) {
                                ForEach(0...$inquiryModel.resultSents.count-1, id: \.self) { i in
                                    NavigationLink(destination: DetailView(carId: inquiryModel.resultSents[i].object(forKey: "carid") as? String ?? "", uid: inquiryModel.resultSents[i].object(forKey: "uid") as? String ?? "")) {
                                        MyInquiryCell(carModel: CarObj(dict: inquiryModel.resultSents[i]), isReceived: false, deleteSuccess: self.deleteSuccess )
                                   }
                                   .isDetailLink(false)
                                   .buttonStyle(ButtonNormal())
                                }

                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        Spacer()
                    }
                   
                   
                }
            }
        }
        .onAppear(perform: {
            if inquiryModel.apiStateReceiver == .loading{
                inquiryModel.loadAPIReceivers { success in
                    
                }
            }
            if inquiryModel.apiState == .loading{
                inquiryModel.loadAPISent { success in
                    
                }
            }
        })
    }
    
    private func deleteSuccess(){
        if indexSegemt == 0 {
            inquiryModel.loadAPIReceivers { success in
                
            }
        }
        else{
            inquiryModel.loadAPISent { success in
                
            }
        }
    }
}

