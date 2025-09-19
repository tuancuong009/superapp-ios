//
//  DetailView.swift
//  Karkonex
//
//  Created by QTS Coder on 22/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
import MessageUI
import SwiftUIPresent
struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewCarModel = ViewCarModel()
    @StateObject var myProfileModel = MyProfileModel()
    let carId: String
    let uid: String
    @State var isModal: Bool = false
    @State var isShowPrewImage: Bool = false
    @State private var isAlert: Bool = false
    @State private var isShowMessage: Bool = false
    @State private var isPreviewImage: Bool = false
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isPresented: Bool = false
    @State var currentIndex: Int = 0
    @State var mediaItems: [SwipingMediaItem] = []
    
    var body: some View {
       VStack{
            header
           if viewCarModel.apiState == .loading{
               HStack{
                   ProgressView {
                       
                   }
               }
               Spacer()
           }
           else{
               if viewCarModel.apiState == .failure {
                   NoDataView(message: "No data")
                   Spacer()
               }
               else{
                   ScrollView(.vertical, showsIndicators: false) {
                       VStack(alignment: .leading,spacing: 20, content: {
                           HStack{
                               Text("\(viewCarModel.carObj.make) \(viewCarModel.carObj.model) \(viewCarModel.carObj.year)")
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22)).multilineTextAlignment(.leading)
                               Spacer(minLength: 0)
                               Text(viewCarModel.carObj.type ? "For Rent" : "For Sale")
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 14))
                                   .padding(5)
                                   .background(Color.init(hex: "#870B0B"))
                                   .foregroundColor(.white)
                                   .cornerRadius(5)
                           }
                           ScrollView(.horizontal, showsIndicators: false){
                               
                               HStack(spacing: 10, content: {
                                   if !viewCarModel.carObj.img1.isEmpty{
                                       Button(action: {
                                           isPreviewImage.toggle()
                                       }, label: {
                                           WebImage(url: URL(string: viewCarModel.carObj.img1)) { image in
                                               image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use
                                           } placeholder: {
                                               Rectangle().foregroundColor(.gray)
                                           }
                                           // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                                           .onSuccess { image, data, cacheType in
                                               // Success
                                               // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                           }
                                           .resizable()
                                           .indicator(.activity) // Activity Indicator
                                           .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                           .scaledToFill()                  // Scales the image to fit within the frame while maintaining aspect ratio
                                           .frame(width: 100, height: 100) // Sets the fixed frame for the image
                                           .clipped()                      // Clips the image to the specified frame
                                           .border(Color.gray, width: 2)
                                           .onTapGesture {
                                               currentIndex = 0
                                               isPresented = true
                                           }
                                       })
                                       .buttonStyle(ButtonNormal())
                                       
                                      
                                   }
                                   
                                   
                                   if !viewCarModel.carObj.img2.isEmpty{
                                       WebImage(url: URL(string: viewCarModel.carObj.img2)) { image in
                                           image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use
                                       } placeholder: {
                                           Rectangle().foregroundColor(.gray)
                                       }
                                       // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                                       .onSuccess { image, data, cacheType in
                                           // Success
                                           // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                       }
                                       .resizable()
                                       .indicator(.activity) // Activity Indicator
                                       .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                       .scaledToFill()                  // Scales the image to fit within the frame while maintaining aspect ratio
                                       .frame(width: 100, height: 100) // Sets the fixed frame for the image
                                       .clipped()                      // Clips the image to the specified frame
                                       .border(Color.gray, width: 2)
                                       .onTapGesture {
                                           currentIndex = 1
                                           isPresented = true
                                       }
                                   }
                                   if !viewCarModel.carObj.img3.isEmpty{
                                       WebImage(url: URL(string: viewCarModel.carObj.img3)) { image in
                                           image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use
                                       } placeholder: {
                                           Rectangle().foregroundColor(.gray)
                                       }
                                       // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                                       .onSuccess { image, data, cacheType in
                                           // Success
                                           // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                       }
                                       .resizable()
                                       .indicator(.activity) // Activity Indicator
                                       .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                       .scaledToFill()                  // Scales the image to fit within the frame while maintaining aspect ratio
                                       .frame(width: 100, height: 100) // Sets the fixed frame for the image
                                       .clipped()                      // Clips the image to the specified frame
                                       .border(Color.gray, width: 2)
                                       .onTapGesture {
                                           currentIndex = 2
                                           isPresented = true
                                       }
                                   }
                                   if !viewCarModel.carObj.img4.isEmpty{
                                       WebImage(url: URL(string: viewCarModel.carObj.img4)) { image in
                                           image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use
                                       } placeholder: {
                                           Rectangle().foregroundColor(.gray)
                                       }
                                       // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                                       .onSuccess { image, data, cacheType in
                                           // Success
                                           // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                                       }
                                       .resizable()
                                       .indicator(.activity) // Activity Indicator
                                       .transition(.fade(duration: 0.5)) // Fade Transition with duration
                                       .scaledToFill()                  // Scales the image to fit within the frame while maintaining aspect ratio
                                       .frame(width: 100, height: 100) // Sets the fixed frame for the image
                                       .clipped()                      // Clips the image to the specified frame
                                       .border(Color.gray, width: 2)
                                       .onTapGesture {
                                           currentIndex = 3
                                           isPresented = true
                                       }
                                   }
                                   
                               })
                           }
                           
                           HStack{
                               Spacer()
                               NavigationLink(destination: ProfileView(profileId: self.myProfileModel.user.id)) {
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
                                       .frame(width: 80, height: 80)
                                       .overlay(Circle().stroke(Color.init(hex: "#870B0B"),lineWidth:3).shadow(radius: 10))
                                       
                                       Text("\(myProfileModel.user.username)  -  \(!myProfileModel.user.status ? "Private Owner" : "Company/Dealer")")
                                           .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 20.0)).multilineTextAlignment(.leading)
                                           .foregroundColor(.black)
                                   }
                               }
                               .isDetailLink(false)
                               
                              
                               
                               Spacer()
                           }
                           
                           HStack(alignment: .center, spacing: 10, content: {
                            Spacer(minLength: 5)
                               Button (
                                   action: {
                                       let telephone = "tel://"
                                       let formattedString = telephone + myProfileModel.user.phone
                                       
                                           guard let url = URL(string: formattedString) else { return }
                                           UIApplication.shared.open(url)
                                   },
                                   label: {
                                       HStack(spacing: 5, content: {
                                           Image("ic_call_selected")
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fill)
                                                  .frame(width: 24, height: 24)
                                           Text("Call Me") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15)).lineLimit(1)
                                               .foregroundColor(Color.white)
                                       })
                                       .padding(10)
                                       .background(Color.init(hex: "#870B0B"))
                                       .cornerRadius(24) /// make the background rounded
                                       .overlay( /// apply a rounded border
                                           RoundedRectangle(cornerRadius: 24)
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
                                       HStack(spacing: 5, content: {
                                           Image("ic_email")
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fill)
                                                  .frame(width: 24, height: 24)
                                          Text("Email") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15)).lineLimit(1)
                                               .foregroundColor(Color.white)
                                       })
                                       .padding(10)
                                       .background(Color.init(hex: "#137b07"))
                                       .cornerRadius(24) /// make the background rounded
                                       .overlay( /// apply a rounded border
                                           RoundedRectangle(cornerRadius: 24)
                                               .stroke(Color.init(hex: "#137b07"), lineWidth: 1)
                                       )
                                    
                               })
                               
                               Button (
                                   action: {
                                       isShowMessage.toggle()
                                   },
                                   label: {
                                       HStack(spacing: 5, content: {
                                           Image("ic_message")
                                                  .resizable()
                                                  .aspectRatio(contentMode: .fill)
                                                  .frame(width: 24, height: 24)
                                           Text("Message") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15)).lineLimit(1).minimumScaleFactor(0.5)
                                               .foregroundColor(Color.white)
                                       })
                                       .padding(10)
                                       .background(Color.init(hex: "#870B0B"))
                                       .cornerRadius(24) /// make the background rounded
                                       .overlay( /// apply a rounded border
                                           RoundedRectangle(cornerRadius: 24)
                                               .stroke(Color.init(hex: "#870B0B"), lineWidth: 1)
                                       )
                                    
                               })
                               Spacer(minLength: 5)
                           })
                           
                           VStack(alignment: .leading, spacing: 10, content: {
                               Text(viewCarModel.carObj.type  ? "$\(viewCarModel.carObj.rent)/ Per Day $\(viewCarModel.carObj.rentw)/ Weekly $\(viewCarModel.carObj.rentm)/ Month" : "Price: $\(viewCarModel.carObj.rent)")
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               Text(viewCarModel.carObj.city)
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               Text("Description:".uppercased())
                                   .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               Text(viewCarModel.carObj.desc)
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               Text("PICKUP LOCATION:")
                                   .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               Text(viewCarModel.carObj.address)
                                   .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18.0)).multilineTextAlignment(.leading)
                                   .foregroundColor(.black)
                               if Auth.shared.hasPremium(){
                                   NavigationLink(destination: BookNowView(carModel: self.viewCarModel.carObj)) {
                                       Text("Book Now")
                                           .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                                   }
                                   .isDetailLink(false)
                                   .buttonStyle(BlueButton())
                               }
                               
                           })
                       }).padding()
                   }
                   
                    Spacer()
               }
           }
           
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $isModal, onDismiss: {
            
            
        }, content: {
            ReportView(clickReport: self.showAlert).presentationDetents([.height(250)])
        })
        .alert(isPresented: $isAlert) {
            
            AlertHelper.shared.showAlertMessage("Thanks for your report!")
        }
        .onAppear(perform: {
            if viewCarModel.apiState == .loading{
                viewCarModel.loadApi(cardID: self.carId, uid: self.uid) { success in
                    self.mediaItems.removeAll()
                    if !self.viewCarModel.carObj.img1.isEmpty{
                        self.mediaItems.append(SwipingMediaItem(url: self.viewCarModel.carObj.img1,
                                                           type: .image,
                                                           shouldShowDownloadButton: false))
                        
                    }
                    if !self.viewCarModel.carObj.img2.isEmpty{
                        self.mediaItems.append(SwipingMediaItem(url: self.viewCarModel.carObj.img2,
                                                           type: .image,
                                                           shouldShowDownloadButton: false))
                    }
                    if !self.viewCarModel.carObj.img3.isEmpty{
                        self.mediaItems.append(SwipingMediaItem(url: self.viewCarModel.carObj.img3,
                                                           type: .image,
                                                           shouldShowDownloadButton: false))
                    }
                    if !self.viewCarModel.carObj.img4.isEmpty{
                        self.mediaItems.append(SwipingMediaItem(url: self.viewCarModel.carObj.img4,
                                                           type: .image,
                                                           shouldShowDownloadButton: false))
                    }
                }
            }
            
            if myProfileModel.apiState == .loading{
                myProfileModel.loadAPIByUserId(userId: self.uid)
            }
            
        })
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result, recipients: [myProfileModel.user.email])
        }
        
        .sheet(isPresented: $isShowMessage, onDismiss: {
            
        }, content: {
            MessageMeView(profileId: self.myProfileModel.user.id, profileName: self.myProfileModel.user.firstName + " " + self.myProfileModel.user.lastName) .presentationDetents([.height(350)])
        })
        .fullScreenCover(isPresented: $isPresented) {
                   ZStack{
                       SwipingMediaView(mediaItems: mediaItems,
                                        isPresented: $isPresented,
                                        currentIndex: $currentIndex,
                                        startingIndex: currentIndex)
                   }
                   // Adding a clear background helper here to achieve on drag fading background effect
                   .background(BackgroundCleanerView())
                   // Ignoring safe area so pinch to zoom don't get cut off
                   .ignoresSafeArea(.all)
               }
        
    }
    
    func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isAlert.toggle()
        }
       
    }
}

extension DetailView {
    var header: some View {
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
                Text(viewCarModel.carObj.pid.uppercased()).lineLimit(1)
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
