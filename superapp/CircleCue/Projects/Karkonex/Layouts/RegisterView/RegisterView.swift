//
//  RegisterView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/04/2024.
//


import SwiftUI
import Alamofire
//import SwiftSpinner
struct RegisterView: View {
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    @State var isAlert = false
    @State var isLoading = false
    @State var showImagePicker: Bool = false
    @State var showChoosePhoto: Bool = false
    @State var indexPhoto: Int = 0
    @State var stateID = ""
    @State var countryID = "231"
    @State var appRouter: AppRouter
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isModal: Bool = false
    @State var isModalState: Bool = false
    @State private var showPicker = false
    @State private var isApiState = false
    @State private var pickerData: [String] = []
    @State private var isCountryPicker = false
    @FocusState private var amountIsFocused: Bool
    @State var iShowHidePassword = false
    @State var isMain = false
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image("btnback") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            Text("")
        }
    }
    }
    var body: some View {
        if isMain{
            BaseView().environmentObject(appRouter)
        }
        else{
            ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
                ScrollView(.vertical, showsIndicators: false){
                    VStack {
                        SocialLoginView(textNavi: "Or Signup With", appRouter: self.appRouter, onSignInSuccess: {
                            appRouter.stateSideMenu = .home
                            appRouter.state = .home
                            print("SUCCESS")
                        },
                        onSignInFailure: { error in
                            viewModel.msgError = error
                            isAlert = true
                        })
                        VStack(spacing: 20.0){
                            HStack(alignment: .center, spacing: 10, content: {
                                
                                Button {
                                    viewModel.isPrivateOwner = true
                                    viewModel.isCompanyDealer = false
                                } label: {
                                    Image(uiImage: (viewModel.isPrivateOwner ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("Private Owner")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                
                                Button {
                                    viewModel.isPrivateOwner = false
                                    viewModel.isCompanyDealer = true
                                } label: {
                                    Image(uiImage: (viewModel.isCompanyDealer ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("Company/Dealer")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                
                                
                            })
                            HStack(spacing: 10, content: {
                                VStack(alignment: .leading, spacing: 10){
                                    Text("First Name")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                    TextField("First Name", text: $viewModel.firstName)
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .keyboardType(.default)
                                        .submitLabel(.next)
                                        .textContentType(.name)
                                        .textInputAutocapitalization(.words)
                                        .onSubmit {
                                            print("Next")
                                        }.focused($amountIsFocused)
                                }
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Last Name")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                    TextField("Last Name", text: $viewModel.lastName)
                                        .textFieldStyle(OvalTextFieldStyle())
                                        .keyboardType(.default)
                                        .submitLabel(.next)
                                        .textContentType(.name)
                                        .onSubmit {
                                            print("Next")
                                        }.focused($amountIsFocused)
                                        .textInputAutocapitalization(.words)
                                }
                            })
                            VStack(alignment: .leading, spacing: 5){
                                Text("Company")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Company", text: $viewModel.company)
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
                                Text("Username")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Username", text: $viewModel.username)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .textContentType(.username)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.never)
                            }
                            VStack(alignment: .leading, spacing: 5){
                                Text("Email")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Email", text: $viewModel.email)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .submitLabel(.next)
                                    .textContentType(.emailAddress)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                                    .textInputAutocapitalization(.never)
                            }
                            VStack(alignment: .leading, spacing: 5){
                                Text("Password")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                HStack{
                                    if iShowHidePassword {
                                        TextField("Password", text: $viewModel.password)
                                            .textFieldStyle(OvalPasswordTextFieldStyle())
                                            .keyboardType(.default)
                                            .submitLabel(.next)
                                            .textContentType(.password)
                                            .onSubmit {
                                                print("Next")
                                            }.focused($amountIsFocused)
                                    } else {
                                        SecureField("Password", text:$viewModel.password)
                                            .textFieldStyle(OvalPasswordTextFieldStyle())
                                            .submitLabel(.next).focused($amountIsFocused)
                                    }
                                    
                                   
                                    Spacer()
                                    Button(action: {
                                        iShowHidePassword.toggle()
                                    }, label: {
                                        Image(!iShowHidePassword ? "ic_show" : "ic_hide")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(5)
                                    })
                                }.overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                              
                            }
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("Telephone")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Telephone", text: $viewModel.phone)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    .submitLabel(.next)
                                    .textContentType(.telephoneNumber)
                                    .onSubmit {
                                        print("Next")
                                    }.focused($amountIsFocused)
                            }
                            HStack(spacing: 10, content: {
                                
                                Button {
                                    viewModel.isVisiblePhone = true
                                    viewModel.isHiddenPhone = false
                                } label: {
                                    Image(uiImage: (viewModel.isVisiblePhone ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("Visible")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                
                                Button {
                                    viewModel.isVisiblePhone = false
                                    viewModel.isHiddenPhone = true
                                } label: {
                                    Image(uiImage: (viewModel.isHiddenPhone ? UIImage.init(named: "ic_radio_select") : UIImage.init(named: "ic_radio")!)!)
                                    Text("Hidden")
                                } .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                Spacer()
                                
                                
                            }).padding(.leading, 0)
                            VStack(alignment: .leading, spacing: 5){
                                Text("Location Address")
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                TextField("Address", text: $viewModel.address)
                                    .textFieldStyle(OvalTextFieldStyle())
                                    .keyboardType(.default)
                                    .submitLabel(.next)
                                    .textContentType(.name)
                                    .onSubmit {
                                        print("Next")
                                    }
                                    .focused($amountIsFocused)
                                    .textInputAutocapitalization(.words)
                            }
                            
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
                                        .keyboardType(.numberPad)
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
                                            HStack {
    //
                                                Text("United States") .foregroundColor(Color.black).lineLimit(1).disabled(true)
                                            }
                                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            
                                            .padding()
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                            )
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
                            }
                            
                            VStack(alignment: .leading) {
                               
                                VStack(alignment: .leading, spacing: 10){
                                    Text("Profile Photo")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                 
                                    HStack{
                                        if viewModel.avatar != nil{
                                            Image(uiImage: viewModel.avatar!)
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
                                    Spacer()
                                    
                                }
                                
                                Spacer()
                            }
                            Button (
                                action: {
                                    callActionRegister()
                                },
                                label: {
                                    Text("Sign Up")
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                })
                            .buttonStyle(BlueButton())
                            
                            
                            Text("Fake or Spam Profiles will be deleted and user banned.")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                            
                        }.padding(5)
                        
                    }
                }
                
                .alert(isPresented: $isAlert) {
                    
                    AlertHelper.shared.showAlertMessage(viewModel.msgError)
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
                            viewModel.avatar = image
                            self.showChoosePhoto.toggle()
                            self.showImagePicker = false
                        }
                    }
                    else{
                        ImagePickerView(sourceType: .photoLibrary) { image in
                            viewModel.avatar = image
                            self.showChoosePhoto = false
                            self.showImagePicker = false
                        }
                    }
                    
                })
                .sheet(isPresented: $isModal, onDismiss: {
                    isModal = false
                    if let id = viewModel.country.object(forKey: "id") as? String, id != countryID{
                        countryID = id
                        isApiState = true
                        viewModel.state = NSDictionary.init()
                        viewModel.states.removeAll()
                        APIKarkonexHelper .shared.getStates(countryId: id) { success, dict in
                            if let dict = dict{
                                isApiState = false
                                viewModel.states = dict
                            }
                        }
                    }
                }, content: {
                    PickerView(selection: $viewModel.country, items: viewModel.countries, title: "Country") .presentationDetents([.height(350)])
                })
                .sheet(isPresented: $isModalState, onDismiss: {
                    isModalState = false
                    if let id = viewModel.state.object(forKey: "id") as? String{
                        stateID = id
                    }
                    
                }, content: {
                    PickerView(selection: $viewModel.state, items: viewModel.states, title: "State") .presentationDetents([.height(350)])
                })
                .onAppear(perform: {
    //                if viewModel.countries.isEmpty{
    //                    APIKarkonexHelper.shared.getCountries { success, dict in
    //                        if let dict = dict{
    //                            viewModel.countries = dict
    //                        }
    //                    }
    //                }
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
                .navigationBarHidden(false)
                .padding()
                .navigationTitle("Create account".uppercased())
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .toolbar(){
                    ToolbarItemGroup(placement: .keyboard){
                        Spacer()
                        Button("Done"){
                            amountIsFocused = false
                        }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MyNotification"))) { notification in
                    appRouter.stateSideMenu = .home
                    appRouter.state = .home
                    print("SUCCESS")
                    isMain = true
                    NotificationCenter.default.removeObserver(self)
                }
            }
        }
        
        
    }
    
    private func callActionRegister(){
        if viewModel.firstName.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.FIRSTNAME_REQUIRED
            isAlert = true
        }
        else if viewModel.lastName.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.LASTNAME_REQUIRED
            isAlert = true
        }
        else if (viewModel.company.trimText().isEmpty && viewModel.isCompanyDealer){
            viewModel.msgError = ERROR_MESSAGE.COMPANY_REQUIRED
            isAlert = true
        }
        else if viewModel.username.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.USERNAME_REQUIRED
            isAlert = true
        }
        else if viewModel.email.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.EMAIL_REQUIRED
            isAlert = true
        }
        else if !viewModel.email.trimText().isValidEmail(){
            viewModel.msgError = ERROR_MESSAGE.EMAIL_INVALID
            isAlert = true
        }
        else if viewModel.password.isEmpty{
            viewModel.msgError = ERROR_MESSAGE.PASSWORD_REQUIRED
            isAlert = true
        }
        else if viewModel.phone.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.TELEPHONE_REQUIRED
            isAlert = true
        }
//        else if viewModel.address.trimText().isEmpty{
//            viewModel.msgError = ERROR_MESSAGE.LOCATION_REQUIRED
//            isAlert = true
//        }
//        else if viewModel.city.trimText().isEmpty{
//            viewModel.msgError = ERROR_MESSAGE.CITY_REQUIRED
//            isAlert = true
//        }
//        else if viewModel.zipCode.trimText().isEmpty{
//            viewModel.msgError = ERROR_MESSAGE.ZIPCODE_REQUIRED
//            isAlert = true
//        }
        else if countryID.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.COUNTRY_REQUIRED
            isAlert = true
        }
//        else if stateID.trimText().isEmpty{
//            viewModel.msgError = ERROR_MESSAGE.STATE_REQUIRED
//            isAlert = true
//        }
        else if viewModel.avatar == nil {
            viewModel.msgError = ERROR_MESSAGE.AVATAR_REQUIRED
            isAlert = true
        }
        else{
            UIApplication.shared.endEditing()
            isLoading = true
            let param = ["fname": viewModel.firstName, "lname": viewModel.lastName, "username": viewModel.username, "email": viewModel.email, "password": viewModel.password, "phone": viewModel.phone, "phone_status": viewModel.isVisiblePhone ? "1" : "0", "status": viewModel.isPrivateOwner ? "1": "0", "company": viewModel.company, "address": viewModel.address, "city": viewModel.city, "state": stateID, "country": countryID, "zip": viewModel.zipCode] as [String : Any]
            APIKarkonexHelper.shared.uploadPhoto(param, viewModel.avatar!) { success, errer in
                isLoading = false
                if success!{
                    appRouter.stateSideMenu = .home
                    appRouter.state = .home
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "REGISTERSSUCCESS"), object: nil)
                }
                else{
                    if let error = errer{
                        viewModel.msgError = error
                        isAlert = true
                    }
                }
            }
        }
    }
}


