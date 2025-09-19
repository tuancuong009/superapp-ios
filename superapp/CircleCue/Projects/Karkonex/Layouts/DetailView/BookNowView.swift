//
//  BookNowView.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI
import Alamofire
struct BookNowView: View {
    @State private var isRentDay = true
    @State private var isRentWeek = false
    @State private var isRentMonth = false
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var amount: String = ""
    @State private var background: String = ""
    @State private var drivingLincese: String = ""
    
    @State private var cardNumber: String = ""
    @State private var cardName: String = ""
    @State private var exp: String = ""
    @State private var cvv: String = ""
    @State private var zip: String = ""
    @State private var phone: String = ""
    @State private var msgError: String = ""
    @State private var file: UIImage?
    @FocusState private var amountIsFocused: Bool
    @State private var isAlert: Bool = false
    @State private var isAlertApi: Bool = false
    @State private var isLoading: Bool = false
    @State var isShowFrom: Bool = false
    @State var isShowTo: Bool = false
    @State var showImagePicker: Bool = false
    @State var showChoosePhoto: Bool = false
    @State var indexPhoto: Int = 0
    @State var dateFrom =  Date()
    @State var dateTo =  Date()
    let carModel: CarObj
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            header
            ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20, content: {
                        if carModel.type{
                            HStack(alignment: .center, spacing: 10, content: {
                                Button {
                                  isRentDay = true
                                  isRentWeek = false
                                  isRentMonth = false
                                  to = ""
                                    amount = ""
                                } label: {
                                    Image(uiImage: (isRentDay ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("$\(carModel.rent)/Day")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                    .lineLimit(1).minimumScaleFactor(0.5)
                                
                                Button {
                                    isRentDay = false
                                    isRentWeek = true
                                    isRentMonth = false
                                    to = ""
                                    amount = ""
                                } label: {
                                    Image(uiImage: (isRentWeek ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("$\(carModel.rentw)/Week")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black) .lineLimit(1).minimumScaleFactor(0.5)
                                
                                Button {
                                    isRentDay = false
                                    isRentWeek = false
                                    isRentMonth = true
                                    to = ""
                                    amount = ""
                                } label: {
                                    Image(uiImage: (isRentMonth ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("$\(carModel.rentm)/Month")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black) .lineLimit(1).minimumScaleFactor(0.5)
                            })
                            // DATE
                            ZStack {
                                VStack(spacing: 0) {
                                    HStack{
                                        VStack(alignment: .leading, spacing: 10){
                                            Text("From")
                                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                                .foregroundColor(Color.black)
                                            Button(action: {
                                                UIApplication.shared.endEditing()
                                                isShowFrom.toggle()
                                            }) {
                                                HStack {
                                                    if !from.isEmpty{
                                                        Text(from) .foregroundColor(Color.black).lineLimit(1)
                                                    }
                                                    else{
                                                        Text("dd/mm/yyyy").foregroundColor(Color.init(hex: "#838383"))
                                                    }
                                                    
                                                    Spacer()
                                                    Image(uiImage: UIImage.init(named: "ic_cal")!)
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
                                            if isRentDay{
                                                Text("Till")
                                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                                    .foregroundColor(Color.black)
                                                Button(action: {
                                                    UIApplication.shared.endEditing()
                                                    self.showChoosePhoto = false
                                                    self.showImagePicker = false
                                                    isShowTo.toggle()
                                                }) {
                                                    HStack {
                                                        if !to.isEmpty{
                                                            Text(to) .foregroundColor(Color.black).lineLimit(1)
                                                        }
                                                        else{
                                                            Text("dd/mm/yyyy").foregroundColor(Color.init(hex: "#838383"))
                                                        }
                                                        
                                                        Spacer()
                                                        Image(uiImage: UIImage.init(named: "ic_cal")!)
                                                        
                                                    }
                                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                                    .padding()
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                                    )
                                                }
                                            }
                                            else if isRentWeek{
                                                Text("Enter Number Of Week") .lineLimit(1).minimumScaleFactor(0.5)
                                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                                    .foregroundColor(Color.black)
                                                TextField("", text: $to)
                                                    .textFieldStyle(OvalTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                                    .submitLabel(.next)
                                                    .textContentType(.name)
                                                    .onChange(of: to) { text in
                                                        self.callDue()
                                                        }
                                                    .onSubmit {
                                                        print("Next")
                                                    }.focused($amountIsFocused)
                                                    .textInputAutocapitalization(.never)
                                            }
                                            else if isRentMonth{
                                                Text("Enter Number Of Month") .lineLimit(1).minimumScaleFactor(0.5)
                                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                                    .foregroundColor(Color.black)
                                                TextField("", text: $to)
                                                    .textFieldStyle(OvalTextFieldStyle())
                                                    .keyboardType(.numberPad)
                                                    .submitLabel(.next)
                                                    .textContentType(.name)
                                                    .onChange(of: to) { text in
                                                        self.callDue()
                                                        }
                                                    .onSubmit {
                                                        print("Next")
                                                    }.focused($amountIsFocused)
                                                    .textInputAutocapitalization(.never)
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                        }
                        if carModel.type
                        {
                            VStack(alignment: .leading, spacing: 5){
                                Text("Amount Due Now")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("$", text: $amount)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .textContentType(.name)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.never)
                                    .disabled(true)
                            }
                        }
                        else{
                            VStack(alignment: .leading, spacing: 5){
                                Text("Price")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("$", text: $amount)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .textContentType(.name)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.never)
                                    .disabled(true)
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("Background Check: Last 4 Social Security Number")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            TextField("Background Check", text: $background)
                                .textFieldStyle(OvalTextFieldStyle())
                                .keyboardType(.numberPad)
                                .submitLabel(.next)
                                .onSubmit {
                                    print("Next")
                                }.focused($amountIsFocused)
                                .textInputAutocapitalization(.never)
                        }
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text("Driving License")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            TextField("Driving License", text: $drivingLincese)
                                .textFieldStyle(OvalTextFieldStyle())
                                .keyboardType(.default)
                                .submitLabel(.next)
                                .onSubmit {
                                    print("Next")
                                }.focused($amountIsFocused)
                                .textInputAutocapitalization(.characters)
                        }
                        
                        VStack(alignment: .leading) {
                           
                            VStack(alignment: .leading, spacing: 5){
                                Text("Upload Driving License Photo")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                HStack{
                                    if file != nil{
                                        Image(uiImage: file!)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .background(Color.gray.opacity(0.2))
                                    }
                                    
                                    Button {
                                        self.showImagePicker.toggle()
                                    } label: {
                                        Text("Choose Photo")
                                    } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.init(hex: "#870B0B"))
                                    Spacer()
                                }
                                
                            }
                            
                        }
                        Divider()
                        Text("Payment") .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: SIZE_FONT_NAV))
                            .foregroundColor(Color.black)
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 5){
                                Text("Credit/Debit Card NO.")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black).lineLimit(1).truncationMode(.tail).minimumScaleFactor(0.5)
                                TextField("Card Number", text: $cardNumber)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("Name On The Card")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Card Name", text: $cardName)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                        })
                        
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 5){
                                Text("Expiration")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("mm/yy", text: $exp)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("CVV")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("CVV", text: $cvv)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                        })
                        HStack(spacing: 10, content: {
                            VStack(alignment: .leading, spacing: 5){
                                Text("Zip")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Zip", text: $zip)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("Phone")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Phone", text: $phone)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.characters)
                            }
                        })
                        Button (
                            action: {
                                
                                self.callApi()
                            },
                            label: {
                            Text("Book Now")
                                .frame(maxWidth: .infinity, maxHeight: 30)
                        })
                        .buttonStyle(BlueButton())
                        
                        Text("Documentnnex will conduct a background check and review your MVA record before handing over the car. If the background check is approved, you will receive confirmation of where to pick up the car or where it will be dropped off. If the check reveals derogatory information, a full refund will be issued, and you will not be able to rent throdocumentnnex.") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15))
                            .foregroundColor(Color.black)
                    }).padding()
                    Spacer()
                }
            }
            
        }
        .onAppear(perform: {
            if !carModel.type{
                amount = carModel.rent
            }
        })
        .toolbar(){
            ToolbarItemGroup(placement: .keyboard){
                Spacer()
                Button("Done"){
                    amountIsFocused = false
                }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                    .foregroundColor(Color.black)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isAlert) {
            if isAlertApi{
                Alert(title: Text(APP_NAME), message: Text(msgError), dismissButton: .cancel(Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
            else{
                AlertHelper.shared.showAlertMessage(msgError)
            }
           
        }
       
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
                    file = image
                    self.showChoosePhoto.toggle()
                    self.showImagePicker = false
                }
            }
            else{
                ImagePickerView(sourceType: .photoLibrary) { image in
                    file = image
                    self.showChoosePhoto = false
                    self.showImagePicker = false
                }
            }
            
        })
        .sheet(isPresented: $isShowFrom, onDismiss: {
            isShowFrom = false
            from = self.convertDate(date: dateFrom)
            callDue()
            
        }, content: {
           DatePickerView(date: $dateFrom).presentationDetents([.height(350)])
        })
        
        .sheet(isPresented: $isShowTo, onDismiss: {
            isShowTo = false
            to = self.convertDate(date: dateTo)
            callDue()
        }, content: {
           DatePickerView(date: $dateTo).presentationDetents([.height(350)])
        })
    }
    
    private func convertDate(date: Date)->String{
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        return format.string(from: date)
    }
    private func convertDateApi(date: Date)->String{
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: date)
    }
    private func callApi(){
        if self.carModel.type{
            if from.isEmpty{
                msgError = "From is required"
                isAlert = true
            }
            else if to.isEmpty{
                msgError = "Till is required"
                isAlert = true
            }
        }
        
        else if amount.isEmpty{
            msgError = "Amount is required"
            isAlert = true
        }
        else if background.isEmpty{
            msgError = "Background Check is required"
            isAlert = true
        }
        else if drivingLincese.isEmpty{
            msgError = "Driving License is required"
            isAlert = true
        }
        else if file == nil {
            msgError = "Driving License Photo is required"
            isAlert = true
        }
        else if cardNumber.isEmpty{
            msgError = "Card Number is required"
            isAlert = true
        }
        else if cardName.isEmpty{
            msgError = "Card Name is required"
            isAlert = true
        }
        else if exp.isEmpty{
            msgError = "Expiration is required"
            isAlert = true
        }
        else if cvv.isEmpty{
            msgError = "CVV is required"
            isAlert = true
        }
        else if zip.isEmpty{
            msgError = "Zipcode is required"
            isAlert = true
        }
        else if phone.isEmpty{
            msgError = "Phone is required"
            isAlert = true
        }
        else{
            var param: Parameters = [:]
            param["pid"] = carModel.pid
            param["uid"] = Auth.shared.getUserId()
            if isRentDay{
                param["type"] = "day"
            }
            else if isRentWeek{
               param["type"] = "week"
            }
            else{
                param["type"] = "month"
            }
            param["date"] = self.convertDateApi(date: dateFrom)
            param["date2"] = self.convertDateApi(date: dateTo)
            param["due"] = amount
            param["background"] = background
            param["card"] = cardNumber
            param["cname"] = cardName
            param["expiration"] = exp
            param["zip"] = zip
            param["cvv"] = cvv
            param["license"] = drivingLincese
            UIApplication.shared.endEditing()
            isLoading = true
            APIKarkonexHelper.shared.booking(param, file!) { success, errer in
                if success!{
                    msgError = "You have successfully submitted your request."
                    isAlert = true
                    isAlertApi = true
                }
                else{
                    if let msg = errer{
                        msgError = msg
                        isAlert = true
                    }
                   
                }
            }
        }
    }
    
    private func callDue(){
        if isRentDay{
            if !from.isEmpty && !to.isEmpty{
                let numberDay = Calendar.current.numberOfDaysBetween(dateFrom, and: dateTo)
                if let intRent = Int(carModel.rent){
                    amount = "\(numberDay * intRent)"
                }
                else{
                    amount = "0"
                }
            }
            else{
                amount = "0"
            }
        }
        else if isRentWeek{
            if let intRent = Int(carModel.rentw), let toInt = Int(to){
                amount = "\(intRent * toInt)"
            }
            else{
                amount = "0"
            }
        }
        else{
            if let intRent = Int(carModel.rentm), let toInt = Int(to){
                amount = "\(intRent * toInt)"
            }
            else{
                amount = "0"
            }
        }
    }
}


extension BookNowView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Button {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image("btnback")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                Text("Booking Form".uppercased()).lineLimit(1)
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                    .foregroundColor(Color.init(hex: "#870B0B"))
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
