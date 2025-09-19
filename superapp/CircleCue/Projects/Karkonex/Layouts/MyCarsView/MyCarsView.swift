//
//  MyCarsView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI

struct MyCarsView: View {
    @StateObject var viewCarModel = ViewCarModel()
    @State private var isReload: Bool = false
    var body: some View {
        VStack{
            if viewCarModel.apiState == .loading{
                HStack{
                    ProgressView {
                        
                    }
                }
                Spacer()
            }
            else{
                if viewCarModel.mycars.count == 0 {
                    NoDataView(message: "No cars")
                    Spacer()
                }
                else{
                    Collection(data: $viewCarModel.mycars, cols: 1, spacing: 0) { result in
                        MyCarCell(carObj: CarObj.init(dict: result), changeData: self.reloadData)
                    }
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    Spacer()
                }
               
               
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onAppear {
            if !isReload{
                viewCarModel.loadMyCars(isLoad: false)
                isReload = true
            }
            else{
                viewCarModel.loadMyCars(isLoad: isReload)
            }
            
            
        }
        Spacer()
    }
    
    private func reloadData(){
        viewCarModel.loadMyCars(isLoad: isReload)
    }
}

#Preview {
    MyCarsView()
}
