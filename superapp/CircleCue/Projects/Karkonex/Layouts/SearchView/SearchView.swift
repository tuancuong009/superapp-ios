//
//  SearchView.swift
//  Karkonex
//
//  Created by QTS Coder on 22/10/24.
//

import SwiftUI
import Alamofire
struct SearchView: View {
    @StateObject var viewModel: SearchModel = SearchModel()
    @StateObject var homeModel = HomeModel()
    @State private var countryID: String = "231"
    @FocusState private var amountIsFocused: Bool
    @State var isModal: Bool = false
    @State var isModalState: Bool = false
    @State private var isApiState = false
    @State private var isCallApi = true
    @State private var isRent = false
    @State private var isSale = false
    @State private var isBoth = true
    var body: some View {
        VStack{
            VStack{
                HStack(alignment: .center, spacing: 10, content: {
                    Button {
                        isBoth = true
                        isRent = false
                        isSale = false
                    } label: {
                        Image(uiImage: (isBoth ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                        Text("Both")
                    } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                    
                    Button {
                        isRent = true
                        isBoth = false
                        isSale = false
                    } label: {
                        Image(uiImage: (isRent ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                        Text("For Rent")
                    } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                    
                    Button {
                        isRent = false
                        isBoth = false
                        isSale = true
                    } label: {
                        Image(uiImage: (isSale ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                        Text("For Sale")
                    } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                    
                })
                
                HStack(spacing: 10, content: {
                    VStack(alignment: .leading, spacing: 10){
                        Text("City")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("City", text: $viewModel.city)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.default)
                            .submitLabel(.next)
                            .textContentType(.name)
                            .onSubmit {
                                print("Next")
                            }.focused($amountIsFocused)
                            .textInputAutocapitalization(.words)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        Text("Zip Code")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Zip Code", text: $viewModel.zipCode)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.default)
                            .submitLabel(.next)
                            .textContentType(.postalCode)
                            .focused($amountIsFocused)
                            .onSubmit {
                                print("Next")
                            }
                    }
                })
                
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Country")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        Button(action: {
                            UIApplication.shared.endEditing()
                            isModal.toggle()
                        }) {
                            HStack {
                                if let name = viewModel.country.object(forKey: "country_name") as? String{
                                    Text(name) .foregroundColor(Color.black).lineLimit(1)
                                }
                                else{
                                    Text("United States").foregroundColor(Color.black).lineLimit(1)
                                }
                                
                                Spacer()
                                Image(uiImage: UIImage.init(named: "ic_down")!)
                            }
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("State")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        Button(action: {
                            UIApplication.shared.endEditing()
                            isModalState.toggle()
                        }) {
                            HStack {
                                if isApiState{
                                    ProgressView().padding(.leading, 10)
                                    Spacer()
                                    Image(uiImage: UIImage.init(named: "ic_down")!)
                                }
                                else{
                                    if let name = viewModel.state.object(forKey: "name") as? String{
                                        Text(name) .foregroundColor(Color.black).lineLimit(1)
                                    }
                                    else{
                                        Text("State").foregroundColor(Color.init(hex: "#838383"))
                                    }
                                    
                                    Spacer()
                                    Image(uiImage: UIImage.init(named: "ic_down")!)
                                }
                                
                            }
                            .disabled(((viewModel.country.object(forKey: "country_name") as? String) != nil) ? false : true)
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                        }
                    }
                    
                }
            }
            Button (
                action: {
                    self.callApiSearch()
                },
                label: {
                Text("SEARCH")
                    .frame(maxWidth: .infinity, maxHeight: 30)
            })
            .buttonStyle(BlueButton())
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        Spacer(minLength: 10)
        VStack{
            if isCallApi{
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
        .toolbar(){
            ToolbarItemGroup(placement: .keyboard){
                Spacer()
                Button("Done"){
                    amountIsFocused = false
                }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                    .foregroundColor(Color.black)
            }
        }
        .onAppear(perform: {
            if viewModel.countries.isEmpty{
                APIKarkonexHelper.shared.getCountries { success, dict in
                    if let dict = dict{
                        viewModel.countries = dict
                    }
                }
            }
            if homeModel.apiState == .loading{
                var param: Parameters = [:]
                homeModel.loadApiSearch(param: param) { success in
                    isCallApi = false
                }
            }
            
            if viewModel.states.isEmpty{
                isApiState = true
                viewModel.state = NSDictionary.init()
                viewModel.states.removeAll()
                APIKarkonexHelper .shared.getStates(countryId: countryID) { success, dict in
                    if let dict = dict{
                        isApiState = false
                        viewModel.states = dict
                    }
                }
            }
        })
        .sheet(isPresented: $isModal, onDismiss: {
            isModal = false
            if let id = viewModel.country.object(forKey: "id") as? String, id != countryID{
                countryID = id
                viewModel.state = NSDictionary()
                viewModel.states.removeAll()
                isApiState = true
                APIKarkonexHelper .shared.getStates(countryId: id) { success, dict in
                    if let dict = dict{
                        viewModel.states = dict
                        isApiState = false
                    }
                }
            }
        }, content: {
            PickerView(selection: $viewModel.country, items: viewModel.countries, title: "Country") .presentationDetents([.height(350)])
        })
        .sheet(isPresented: $isModalState, onDismiss: {
            isModalState = false
           
            
        }, content: {
            PickerView(selection: $viewModel.state, items: viewModel.states, title: "State") .presentationDetents([.height(350)])
        })
        .edgesIgnoringSafeArea(.bottom)
    }
    
    
    private func callApiSearch(){
        var param: Parameters = [:]
        if !viewModel.city.isEmpty{
            param["city"] = viewModel.city
        }
        if !viewModel.zipCode.isEmpty{
            param["zip"] = viewModel.zipCode
        }
        if let id = viewModel.country.object(forKey: "id") as? String {
            param["country"] = id
        }
        if let id = viewModel.state.object(forKey: "id") as? String {
            param["state"] = id
        }
        param["type"] =  isBoth ? "2" :  (isRent ? "0" : (isSale ? "1": "2"))
        isCallApi = true
        print("PARAM--->",param)
        homeModel.loadApiSearch(param: param) { success in
            isCallApi = false
        }
    }
}



