//
//  MyProfileView.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct MyProfileView: View {
    @StateObject var myProfileModel = MyProfileModel()
    @State private var isDeleteAccount: Bool = false
    @State private var isAlert: Bool = false
    @State private var isLoading: Bool = false
    @State var appRouter: AppRouter
    @State private var imageAvatar: UIImage?
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            ScrollView(showsIndicators: false, content: {
                if myProfileModel.apiState == .loading{
                    HStack{
                        Spacer()
                        ProgressView {
                            
                        }
                        Spacer()
                    }
                }
                else{
                    VStack(spacing: 20, content: {
                        Spacer(minLength: 20)
                        VStack{
                            if imageAvatar != nil{
                                Image(uiImage: imageAvatar!)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 120, height: 120)
                                    .overlay(Circle().stroke(Color.init(hex: "#870B0B"),lineWidth:3).shadow(radius: 10))
                            }
                            else{
                                WebImage(url: URL(string: myProfileModel.user.img)) { image in
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
                        HStack(spacing: 10, content: {
                            Text("First Name")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.firstName)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Last Name")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.lastName)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Phone")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.phone)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Username")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.username)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Email")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.email)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Location Address")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.address)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("City")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.city)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("Zip Code")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.zipCode)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                        HStack(spacing: 10, content: {
                            Text("State")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.state)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                    
                        HStack(spacing: 10, content: {
                            Text("Country")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            Spacer()
                            Text(myProfileModel.user.country)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.init(hex: "#870B0B"))
                                .padding(.trailing, 0)
                        })
                       
                        HStack{
                            NavigationLink(destination: EditProfileView(editImage: self.editImage(_:), profileObj: self.myProfileModel.user)) {
                                Text("Edit Profile").padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                   // .frame(width: 160, height: 40)
                                
                            }
                            .isDetailLink(false)
                            .buttonStyle(PikcerButton())
                            Button {
                                isDeleteAccount.toggle()
                            } label: {
                                Text("Delete Account").padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                  //  .frame(width: 160, height: 40)
                            }.buttonStyle(RedButton())
                            
                            
                            Spacer()
                        }
                        Spacer()
                    }).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            })
        }
        .onAppear(perform: {
            myProfileModel.loadAPI()
        })
        .alert(isPresented: $isDeleteAccount) {
            Alert(
                title: Text(APP_NAME),
                message: Text("Are you sure you want to delete? If you delete it permanently then you will have to re-register."),
                primaryButton: .destructive(Text("Delete")) {
                    isLoading = true
                    myProfileModel.apiDeleteAccount { success, error in
                        isLoading = false
                        appRouter.state = .login
                    }
                },
                secondaryButton: .default(Text("Cancel")) {
                }
            )
        }
    }
    
    private func editImage(_ image: UIImage){
        imageAvatar = image
    }
}

