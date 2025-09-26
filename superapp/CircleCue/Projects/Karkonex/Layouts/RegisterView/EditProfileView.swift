//
//  EditProfileView.swift
//  Karkonex
//
//  Created by QTS Coder on 1/11/24.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI
//import SwiftSpinner
struct EditProfileView: View {
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    @State var isAlert = false
    @State var isLoading = false
    var editImage: (_ image: UIImage) -> Void
    @State var showImagePicker: Bool = false
    @State var showChoosePhoto: Bool = false
    @State var indexPhoto: Int = 0
    let profileObj: UserModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var amountIsFocused: Bool
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
        header
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            ScrollView(.vertical, showsIndicators: false){
                VStack {
                    Spacer(minLength: 20)
                    VStack{
                        Button {
                            self.showImagePicker.toggle()
                        } label: {
                            if viewModel.avatar != nil{
                                Image(uiImage: viewModel.avatar!)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
                                    .overlay(Circle().stroke(Color.init(hex: "#870B0B"),lineWidth:3).shadow(radius: 10))
                            }
                            else{
                                WebImage(url: URL(string: profileObj.img)) { image in
                                    image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                                } placeholder: {
                                    Rectangle().foregroundColor(.gray)
                                }
                                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                                .onSuccess { image, data, cacheType in
                                    // Success
                                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                }
                                .indicator(.activity) // Activity Indicator
                                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                                .overlay(Circle().stroke(Color.init(hex: "#870B0B"),lineWidth:3).shadow(radius: 10))
                            }
                            
                        }
                        
                      
                    }
                    Spacer(minLength: 20)
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
                        
                        Button (
                            action: {
                                callEditProfile()
                            },
                            label: {
                                Text("SAVE")
                                    .frame(maxWidth: .infinity, maxHeight: 50)
                            })
                        .buttonStyle(BlueButton())
                        
                        
                    }
                    
                }
            }
            
            .alert(isPresented: $isAlert) {
                
                AlertHelper.shared.showAlertMessage(viewModel.msgError)
            }
            .onAppear(perform: {
                convertUser()
            })
            .padding(EdgeInsets(top: -8, leading: 20, bottom: 0, trailing: 20))
            .navigationBarHidden(true)
            .toolbar(){
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
            }.actionSheet(isPresented: $showImagePicker, content: {
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
        }
        
    }
    
    private func convertUser(){
        viewModel.isPrivateOwner = profileObj.status
        viewModel.isCompanyDealer = !profileObj.status
        viewModel.firstName = profileObj.firstName
        viewModel.lastName = profileObj.lastName
        viewModel.email = profileObj.email
        viewModel.username = profileObj.username
        viewModel.isVisiblePhone = profileObj.phone_status
        viewModel.isHiddenPhone = !profileObj.phone_status
        viewModel.phone = profileObj.phone
        viewModel.city = profileObj.city
        viewModel.zipCode = profileObj.zipCode
        viewModel.address = profileObj.address
    }
    private func callEditProfile(){
        if viewModel.firstName.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.FIRSTNAME_REQUIRED
            isAlert = true
        }
        else if viewModel.lastName.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.LASTNAME_REQUIRED
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
       
        else if viewModel.phone.trimText().isEmpty{
            viewModel.msgError = ERROR_MESSAGE.TELEPHONE_REQUIRED
            isAlert = true
        }
        
        else{
            UIApplication.shared.endEditing()
            isLoading = true
            if viewModel.avatar != nil{
                let param = ["fname": viewModel.firstName, "lname": viewModel.lastName, "username": viewModel.username, "email": viewModel.email, "phone": viewModel.phone, "phone_status": viewModel.isVisiblePhone ? "1" : "0", "status": viewModel.isPrivateOwner ? "1": "0", "id": AuthKaKonex.shared.getUserId(), "address": viewModel.address, "city": viewModel.city, "zip": viewModel.zipCode] as [String : Any]
                APIKarkonexHelper.shared.editProfileAvatar(param, viewModel.avatar!, complete: { success, errer in
                    isLoading = false
                    if success!{
                        SDImageCache.shared.clearMemory()
                        SDImageCache.shared.clearDisk()
                        self.editImage(viewModel.avatar!)
                        if let error = errer{
                            viewModel.msgError = error
                            isAlert = true
                        }
                    }
                    else{
                        if let error = errer{
                            viewModel.msgError = error
                            isAlert = true
                        }
                    }
                })
            }
            else{
                let param = ["fname": viewModel.firstName, "lname": viewModel.lastName, "username": viewModel.username, "email": viewModel.email, "phone": viewModel.phone, "phone_status": viewModel.isVisiblePhone ? "1" : "0", "status": viewModel.isPrivateOwner ? "1": "0", "id": AuthKaKonex.shared.getUserId(), "address": viewModel.address, "city": viewModel.city, "zip": viewModel.zipCode] as [String : Any]
                APIKarkonexHelper.shared.editProfile(param, complete: { success, erro in
                    isLoading = false
                    if success!{
                        if let error = erro{
                            viewModel.msgError = error
                            isAlert = true
                        }
                    }
                    else{
                        if let error = erro{
                            viewModel.msgError = error
                            isAlert = true
                        }
                    }
                })
            }
        }
    }
}

extension EditProfileView {
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
                Text("Edit Profile".uppercased()).lineLimit(1)
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
