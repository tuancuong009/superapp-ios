//
//  ListHome.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI

struct ListHome: View {
    @StateObject var homeModel = HomeModel()
    @State private var isLoad = false
    var body: some View {
        VStack{
            if homeModel.apiState == .loading{
                HStack{
                    ProgressView {
                        
                    }
                }
                Spacer()
            }
            else{
                if homeModel.results.count == 0 {
                    NoDataView(message: "No data")
                    Spacer()
                }
                else{
                    ScrollView{
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)], spacing: 0) {
                            ForEach(0...$homeModel.results.count-1, id: \.self) { i in
                                NavigationLink(destination: DetailView(carId: homeModel.results[i].object(forKey: "id") as? String ?? "", uid: homeModel.results[i].object(forKey: "uid") as? String ?? "")) {
                                    HomeCell(carModel: CarObj(dict: homeModel.results[i]) )
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
        .onAppear {
            homeModel.loadApi(isReload: isLoad) { success in
                isLoad = true
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ListHome()
}
