//
//  AddCarView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI
import Alamofire
struct AddCarView: View {
    
    @State var addCarModel: AddCarModel = AddCarModel()
    @State var isAlert = false
    @State var isLoading = false
    @State var isModal: Bool = false
    @State var isModalState: Bool = false
    @State private var showPicker = false
    @State private var isApiState = false
    @State private var isRent = true
    @State var stateID = ""
    @State var stateName = ""
    @State var countryID = ""
    @State var photo1: UIImage?
    @State var photo2: UIImage?
    @State var photo3: UIImage?
    @State var photo4: UIImage?
    
    @FocusState private var amountIsFocused: Bool
    @State var showImagePicker: Bool = false
    @State var showChoosePhoto: Bool = false
    @State var postionPhoto: Int = 0
    @State var indexPhoto: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        addCarModel = AddCarModel()
    }
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            VStack{
                headerNavi
                ScrollView{
                    VStack(spacing: 20.0){
                        HStack(alignment: .center, spacing: 10, content: {
                            
                            Button {
                                isRent.toggle()
                            } label: {
                                Image(uiImage: (isRent ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                Text("To Rent")
                            } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            
                            Button {
                                isRent.toggle()
                            } label: {
                                Image(uiImage: (!isRent ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                Text("To Sell")
                            } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            
                            
                        })
                        
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 5){
                                Text("Make")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Make", text: $addCarModel.make)
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
                                Text("Model")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Model", text: $addCarModel.model)
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
                                Text("Year")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Year", text: $addCarModel.year)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .focused($amountIsFocused)
                                    .onSubmit {
                                        print("Next")
                                    }
                            }
                        })
                        
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 5){
                                Text(isRent ? "Rent" : "Price")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField(isRent ? "Per/Day" : "Price", text: $addCarModel.rentDay)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .textContentType(.name)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                            }
                            if isRent{
                                VStack(alignment: .leading, spacing: 5){
                                    Text(" ")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                    TextField("Per/Week", text: $addCarModel.rentweek)
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .submitLabel(.next)
                                        .onSubmit {
                                            print("Next")
                                        }.focused($amountIsFocused)
                                }
                                VStack(alignment: .leading, spacing: 5){
                                    Text(" ")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                    TextField("Per/Month", text: $addCarModel.rentMonth)
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .keyboardType(.numberPad)
                                        .submitLabel(.next)
                                        .focused($amountIsFocused)
                                        .onSubmit {
                                            print("Next")
                                        }
                                }
                            }
                        })
                        VStack(alignment: .leading, spacing: 5){
                            Text("Location Address")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            TextField("Address", text: $addCarModel.location)
                                .textFieldStyle(OvalTextFieldStyle())
                                .keyboardType(.default)
                                .submitLabel(.next)
                                .textContentType(.name)
                                .onSubmit {
                                    print("Next")
                                }
                                .textInputAutocapitalization(.words)
                                .focused($amountIsFocused)
                        }
                        
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 10){
                                Text("City")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("City", text: $addCarModel.city)
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
                                TextField("Zip Code", text: $addCarModel.zipCode)
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
                        
                        ZStack {
                            VStack(spacing: 0) {
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
                                                if let name = addCarModel.country.object(forKey: "country_name") as? String{
                                                    Text(name) .foregroundColor(Color.black).lineLimit(1)
                                                }
                                                else{
                                                    Text("Country").foregroundColor(Color.init(hex: "#838383"))
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
                                            if !countryID.isEmpty{
                                                UIApplication.shared.endEditing()
                                                isModalState.toggle()
                                            }
                                            
                                        }) {
                                            HStack {
                                                if isApiState{
                                                    ProgressView().padding(.leading, 10)
                                                    Spacer()
                                                    Image(uiImage: UIImage.init(named: "ic_down")!)
                                                }
                                                else{
                                                    if !stateName.isEmpty{
                                                        Text(stateName) .foregroundColor(Color.black).lineLimit(1)
                                                    }
                                                    else{
                                                        Text("State").foregroundColor(Color.init(hex: "#838383"))
                                                    }
                                                    
                                                    Spacer()
                                                    Image(uiImage: UIImage.init(named: "ic_down")!)
                                                }
                                                
                                            }
                                            .disabled(((addCarModel.country.object(forKey: "country_name") as? String) != nil) ? false : true)
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
                        }
                        VStack(alignment: .leading, spacing: 10){
                            Text("Description")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            TextField("Description", text: $addCarModel.description)
                                .textFieldStyle(OvalTextFieldStyle())
                                .keyboardType(.default)
                                .submitLabel(.next)
                                .textContentType(.name)
                                .onSubmit {
                                    print("Next")
                                }
                                .textInputAutocapitalization(.words)
                                .focused($amountIsFocused)
                                .lineLimit(5...10)
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                            }
                            VStack(alignment: .leading, spacing: 10){
                                Text("Photos")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                VStack(alignment: .leading, spacing: 10){
                                    HStack{
                                        if photo1 != nil{
                                            Image(uiImage: photo1!)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .background(Color.gray.opacity(0.2))
                                        }
                                        
                                        Button {
                                            self.showImagePicker.toggle()
                                            self.postionPhoto = 0
                                        } label: {
                                            Text("Choose Photo")
                                        } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.init(hex: "#870B0B"))
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        if photo2 != nil{
                                            Image(uiImage: photo2!)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .background(Color.gray.opacity(0.2))
                                        }
                                        
                                        Button {
                                            self.showImagePicker.toggle()
                                            self.postionPhoto = 1
                                        } label: {
                                            Text("Choose Photo")
                                        } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.init(hex: "#870B0B"))
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        if photo3 != nil{
                                            Image(uiImage: photo3!)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .background(Color.gray.opacity(0.2))
                                        }
                                        
                                        Button {
                                            self.showImagePicker.toggle()
                                            self.postionPhoto = 2
                                        } label: {
                                            Text("Choose Photo")
                                        } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.init(hex: "#870B0B"))
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        if photo4 != nil{
                                            Image(uiImage: photo4!)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .background(Color.gray.opacity(0.2))
                                        }
                                        
                                        Button {
                                            self.showImagePicker.toggle()
                                            self.postionPhoto = 3
                                        } label: {
                                            Text("Choose Photo")
                                        } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.init(hex: "#870B0B"))
                                        Spacer()
                                    }
                                }
                               
                                Spacer()
                                
                            }
                            
                            Spacer()
                        }
                        Button (
                            action: {
                                self.callApiAddCar()
                            },
                            label: {
                                Text("List Now")
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                        .buttonStyle(BlueButton())
                        
                    }.padding()
                    
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $isAlert) {
                
                AlertHelper.shared.showAlertMessage(addCarModel.msgError)
            }
            .sheet(isPresented: $isModal, onDismiss: {
                isModal = false
                if let id = addCarModel.country.object(forKey: "id") as? String, id != countryID{
                    countryID = id
                    isApiState = true
                    addCarModel.state = NSDictionary.init()
                    addCarModel.states.removeAll()
                    APIKarkonexHelper .shared.getStates(countryId: id) { success, dict in
                        if let dict = dict{
                            isApiState = false
                            addCarModel.states = dict
                        }
                    }
                }
            }, content: {
                PickerView(selection: $addCarModel.country, items: addCarModel.countries, title: "Country") .presentationDetents([.height(350)])
            })
            .sheet(isPresented: $isModalState, onDismiss: {
                isModalState = false
                if let id = addCarModel.state.object(forKey: "id") as? String{
                    stateID = id
                }
                stateName = addCarModel.state.object(forKey: "name") as? String ?? ""
            }, content: {
                PickerView(selection: $addCarModel.state, items: addCarModel.states, title: "State") .presentationDetents([.height(350)])
            })
            .actionSheet(isPresented: $showImagePicker, content: {
                ActionSheet(title: Text(APP_NAME), message: nil,
                            buttons: [
                                .default(Text("Take a Photo"), action: {
                                    print("Ok selected")
                                    self.indexPhoto = 0
                                    self.showChoosePhoto.toggle()
                                }),
                                .default(Text("Choose a Library"), action: {
                                    self.indexPhoto = 1
                                    self.showChoosePhoto.toggle()
                                }),
                                .cancel(Text("Cancel"), action: {
                                    self.showImagePicker = false
                                })
                                
                            ])
            })
            .sheet(isPresented: $showChoosePhoto, content: {
                
                if self.indexPhoto == 0{
                    ImagePickerView(sourceType: .camera) { image in
                        if postionPhoto == 0 {
                            photo1 = image
                        }
                        else if postionPhoto == 1 {
                            photo2 = image
                        }
                        else if postionPhoto == 2 {
                            photo3 = image
                        }
                        else{
                            photo4 = image
                        }
                        self.showChoosePhoto.toggle()
                        self.showImagePicker = false
                    }
                }
                else{
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        print("postionPhoto--->",postionPhoto)
                        if postionPhoto == 0 {
                            photo1 = image
                        }
                        else if postionPhoto == 1 {
                            photo2 = image
                        }
                        else if postionPhoto == 2 {
                            photo3 = image
                        }
                        else{
                            photo4 = image
                        }
                        self.showChoosePhoto = false
                        self.showImagePicker = false
                    }
                }
                
            })
            .onAppear(perform: {
                if addCarModel.countries.isEmpty{
                    APIKarkonexHelper.shared.getCountries { success, dict in
                        if let dict = dict{
                            addCarModel.countries = dict
                        }
                    }
                }
                
            }) .toolbar(){
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
            }
        }
       
    }
    
    private func callApiAddCar(){
        if addCarModel.make.trimText().isEmpty{
            addCarModel.msgError = "Make is required"
            isAlert = true
        }
        else if addCarModel.model.trimText().isEmpty{
            addCarModel.msgError = "Model is required"
            isAlert = true
        }
        else if addCarModel.year.trimText().isEmpty{
            addCarModel.msgError = "Year is required"
            isAlert = true
        }
        else if addCarModel.rentDay.trimText().isEmpty{
            addCarModel.msgError = isRent ? "Rent/Day is required" : "Price is required"
            isAlert = true
        }
        else if addCarModel.rentweek.trimText().isEmpty && isRent{
            addCarModel.msgError = "Rent/Week is required"
            isAlert = true
        }
        else if addCarModel.rentMonth.trimText().isEmpty && isRent{
            addCarModel.msgError = "Rent/Month is required"
            isAlert = true
        }
        else if addCarModel.location.trimText().isEmpty{
            addCarModel.msgError = "Location Address is required"
            isAlert = true
        }
        else if addCarModel.city.trimText().isEmpty{
            addCarModel.msgError = ERROR_MESSAGE.CITY_REQUIRED
            isAlert = true
        }
        else if addCarModel.zipCode.trimText().isEmpty{
            addCarModel.msgError = ERROR_MESSAGE.ZIPCODE_REQUIRED
            isAlert = true
        }
        else if countryID.trimText().isEmpty{
            addCarModel.msgError = ERROR_MESSAGE.COUNTRY_REQUIRED
            isAlert = true
        }
        else if stateID.trimText().isEmpty{
            addCarModel.msgError = ERROR_MESSAGE.STATE_REQUIRED
            isAlert = true
        }
        else if addCarModel.description.trimText().isEmpty{
            addCarModel.msgError = "Description is required"
            isAlert = true
        }
        else if(photo1 == nil && photo2 == nil && photo3 == nil && photo4 == nil ){
            addCarModel.msgError = "Photos is required"
            isAlert = true
        }
        else{
            amountIsFocused = false
            isLoading = true
            let param = ["uid": Auth.shared.getUserId(), "make": addCarModel.make , "modal": addCarModel.model, "year": addCarModel.year, "rent": addCarModel.rentDay, "rentw": addCarModel.rentweek, "rentm": addCarModel.rentMonth, "address": addCarModel.location, "discription": addCarModel.description, "city": addCarModel.city, "zip": addCarModel.zipCode, "state": stateID, "country": countryID, "type": isRent ? "0" : "1"]
            APIKarkonexHelper.shared.addCar(param, photo1, photo2, photo3, photo4) { success, errer in
                isLoading = false
                if success!{
                    addCarModel = AddCarModel()
                    self.presentationMode.wrappedValue.dismiss()
                }
                else{
                    if let error = errer{
                        addCarModel.msgError = error
                        isAlert = true
                    }
                }
            }
        }
    }
}

#Preview {
    AddCarView()
}


extension AddCarView{
    var headerNavi: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("btnback")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
               
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }.overlay(
            VStack{
                Text("Add Car")
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                    .foregroundColor(Color.init(hex: "#870B0B"))
            }
            
        )
    }
}
