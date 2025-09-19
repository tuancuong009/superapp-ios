//
//  ProfileView.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
import MessageUI
struct ProfileView: View {
    @StateObject var blockModel = BlockModel()
    @StateObject var myProfileModel = MyProfileModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isModal: Bool = false
    @State private var isAlert: Bool = false
    @State private var isAlertBlock: Bool = false
    @State private var isBlock: Bool = false
    @State private var idBlock: String  = ""
    let profileId: String
    var notificationID: String = ""
    @State var message: String  = ""
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowMessage: Bool = false
    var body: some View {
        VStack{
            header
            ScrollView(showsIndicators: false, content: {
                if myProfileModel.apiState == .loading{
                    HStack{
                        ProgressView {
                            
                        }
                    }
                }
                else{
                    VStack(spacing: 20, content: {
                        Spacer(minLength: 10)
                        HStack{
                            Spacer()
                            VStack{
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
                                
                                Text("\(myProfileModel.user.username)  - \(myProfileModel.user.status ? "Private Owner" : "Company/Dealer")")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 20.0)).multilineTextAlignment(.leading)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .center, spacing: 10, content: {
                            Button (
                                action: {
                                    isAlertBlock.toggle()
                                },
                                label: {
                                    HStack{
                                        Image("ic_block")
                                               .resizable()
                                               .aspectRatio(contentMode: .fill)
                                               .frame(width: 24, height: 24)
                                        Text(isBlock ? "Unblock" : "Block") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.white)
                                          
                                    }
                                    .padding(10)
                                    .background(Color.init(hex: "#870B0B"))
                                    .cornerRadius(20) /// make the background rounded
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.init(hex: "#870B0B"), lineWidth: 1)
                                    )
                                 
                            })
                               
                            Button (
                                action: {
                                    if MFMailComposeViewController.canSendMail(){
                                        self.isShowingMailView.toggle()
                                    }
                                },
                                label: {
                                    HStack{
                                        Image("ic_email")
                                               .resizable()
                                               .aspectRatio(contentMode: .fill)
                                               .frame(width: 24, height: 24)
                                       Text("Email") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.white)
                                          
                                    }
                                    .padding(10)
                                    .background(Color.init(hex: "#870B0B"))
                                    .cornerRadius(20) /// make the background rounded
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.init(hex: "#870B0B"), lineWidth: 1)
                                    )
                                 
                            })
                            
                            Button (
                                action: {
                                    isShowMessage.toggle()
                                },
                                label: {
                                    HStack{
                                        Image("ic_message")
                                               .resizable()
                                               .aspectRatio(contentMode: .fill)
                                               .frame(width: 24, height: 24)
                                       Text("Message") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                            .foregroundColor(Color.white)
                                          
                                    }
                                    .padding(10)
                                    .background(Color.init(hex: "#870B0B"))
                                    .cornerRadius(20) /// make the background rounded
                                    .overlay( /// apply a rounded border
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.init(hex: "#870B0B"), lineWidth: 1)
                                    )
                                 
                            })
                               
                        })
                        VStack(spacing: 10) {
                            HStack{
                                Text("Name:")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            HStack{
                                Text(myProfileModel.user.firstName + " " + myProfileModel.user.lastName)
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.init(hex: "#870B0B"))
                                Spacer()
                            }
                        }
                        VStack(spacing: 10) {
                            HStack{
                                Text("Address:")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            HStack{
                                Text(myProfileModel.user.address)
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.init(hex: "#870B0B"))
                                Spacer()
                            }
                        }
                        VStack(spacing: 10) {
                            HStack{
                                Text("State:")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            HStack{
                                Text(myProfileModel.user.state)
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.init(hex: "#870B0B"))
                                Spacer()
                            }
                        }
                        VStack(spacing: 10) {
                            HStack{
                                Text("Country:")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            HStack{
                                Text(myProfileModel.user.country)
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                    .foregroundColor(Color.init(hex: "#870B0B"))
                                Spacer()
                            }
                        }
                        Spacer()
                    }) .padding()
                }
            })
        }
        .navigationBarHidden(true)
       
        .onAppear(perform: {
            myProfileModel.loadAPIByUserId(userId: self.profileId)
            if blockModel.apiState == .loading{
                self.getListBlock()
            }
            if !self.notificationID.isEmpty{
                APIKarkonexHelper.shared.seenNotification(notificationID) { success, erro in
                    
                }
            }
        })
        .sheet(isPresented: $isModal, onDismiss: {
            
            
        }, content: {
            ReportView(clickReport: self.showAlert).presentationDetents([.height(250)])
        })
        .alert(isPresented: $isAlert) {
            
            AlertHelper.shared.showAlertMessage(message)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result, recipients: [myProfileModel.user.email])
        }
        
        .alert(isPresented: $isAlertBlock) {
            Alert(
                title: Text(APP_NAME),
                            message: Text(isBlock ? "Are you sure you want to unblock this user?" : "Are you sure you want to block this user?"),
                            primaryButton: .default(Text("Yes")) {
                                if !isBlock{
                                    let param = ["blockby": Auth.shared.getUserId(), "blocked": self.profileId]
                                    self.isBlock = true
                                    
                                    blockModel.callAddBlock(param) { success in
                                        self.getListBlock()
                                    }
                                }
                                else{
                                    self.isBlock = false
                                    blockModel.deleteBlock(idBlock) { success in
                                        idBlock = ""
                                    }
                                }
                            },
                            secondaryButton: .default(Text("No")) {
                            }
                        )
        }
        .sheet(isPresented: $isShowMessage, onDismiss: {
            
        }, content: {
            MessageMeView(profileId: self.myProfileModel.user.id, profileName: self.myProfileModel.user.firstName + " " + self.myProfileModel.user.lastName) .presentationDetents([.height(350)])
        })
    }
    func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            message = "Thanks for your report!"
            isAlert.toggle()
        }
       
    }
    
    
    private func getListBlock(){
        blockModel.loadAPI { success in
            for item in blockModel.results{
                if let blocked = item.object(forKey: "blocked") as? String, blocked == Auth.shared.getUserId(){
                    self.isBlock = true
                    print("self.isBlock--->",self.isBlock)
                    if let id = item.object(forKey: "id") as? String{
                        self.idBlock = "\(id)"
                        print("UID BLOCK--->",self.idBlock)
                    }
                    break
                }
                
            }
        }
    }
    
}

extension ProfileView {
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
                Text("Profile").lineLimit(1)
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                    .foregroundColor(Color.init(hex: "#870B0B"))
                Spacer()
                
                Button {
                    withAnimation {
                        isModal.toggle()
                    }
                } label: {
                    Image("ic_more")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
