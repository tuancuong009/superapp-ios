//
//  ChatMessageView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct ChatMessageView: View {
    @Environment(\.presentationMode) var presentationMode
    let profileID: String
    let profileName: String
    @State private var messageText = ""
    @State private var isCallApi = false
    @State private var isAlert = false
    @State private var showImagePicker = false
    @State private var showChoosePhoto = false
    @State private var indexPhoto = 0
    @State var isPresented: Bool = false
    @State var currentIndex: Int = 0
    @State var indexMessage: Int = 0
    @State var mediaItems: [SwipingMediaItem] = []
    
    @StateObject var messageFullModel = FullMessageModel()
    @StateObject var addMessageModel = AddMessageModel()
    var body: some View {
        VStack {
           headerNavi
            List {
                ForEach(messageFullModel.messages, id: \.id, content: { message in
                    if message.sender_id  == Auth.shared.getUserId() {
                        VStack{
                            HStack {
                                Spacer()
                                if !message.media.isEmpty{
                                    WebImage(url: URL(string: message.media)) { image in
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
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFit()
                                    .frame(width: 200, height: 120, alignment: .trailing)
                                    .clipShape(RoundedRectangle(cornerRadius: 0))
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        indexMessage = message.index
                                        let seconds = 0.5
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            currentIndex = 0
                                            isPresented = true
                                        }
                                        
                                      
                                    }
                                }
                                else{
                                    Text(message.message)
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .background(Color.blue.opacity(0.8))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 0)
                                        .padding(.bottom, -5)
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 17.0))
                                }
                               
                            }
                            HStack {
                                Spacer()
                               
                                Text( self.formatTimeAgo(message.created_at))
                                     .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 12)).multilineTextAlignment(.trailing)
                                     .foregroundColor(.gray)
                                if message.readstatus == 0{
                                    Image("ic_received")
                                         .resizable()
                                        .frame(width: 12.0, height: 12.0)
                                        .scaledToFit()
                                }
                                
                                
                            } .padding(.horizontal, 0)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)

                    } else {
                        VStack{
                            HStack {
                                if !message.media.isEmpty{
                                    WebImage(url: URL(string: message.media)) { image in
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
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFit()
                                    .frame(width: 200, height: 120, alignment: .leading)
                                    .clipShape(RoundedRectangle(cornerRadius: 0))
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        indexMessage = message.index
                                        let seconds = 0.5
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            currentIndex = 0
                                            isPresented = true
                                        }
                                        
                                      
                                    }
                                }
                                else{
                                    Text(message.message)
                                        .padding()
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 0)
                                        .padding(.bottom, -5)
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 17.0))
                                }
                                
                                
                                Spacer()
                            }
                            HStack {
                                
                                Text( self.formatTimeAgo(message.created_at))
                                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 12)).multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                                Spacer()
                                
                                
                            } .padding(.horizontal, 0)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }).onDelete { (indexSet: IndexSet) in
                    
                }.rotationEffect(.degrees(180))
                    .deleteDisabled(false)
            }
            .listStyle(.plain)
            .rotationEffect(.degrees(180))
            .background(Color.white)
            .onTapGesture {
                print("onTapGesture")
                UIApplication.shared.endEditing()
            }
            .onLongPressGesture {
                
            }
            // Contains the Message bar
            HStack {
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
                .foregroundColor(Color.init(hex: "#870B0B"))
                if #available(iOS 16.0, *) {
                    TextField("Type something", text: $messageText, axis: .vertical)
                        .padding()
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 17.0)).multilineTextAlignment(.leading)
                        .lineLimit(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onSubmit {
                            sendMessage(message: messageText)
                        }
                } else {
                    // Fallback on earlier versions
                }
                if isCallApi{
                    ProgressView() .padding(.horizontal, 10)
                }
                else{
                    Button {
                        sendMessage(message: messageText)
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .font(.system(size: 26))
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.init(hex: "#870B0B"))
                }
               
            }
            .padding(EdgeInsets(top: -8, leading: 20, bottom: 0, trailing: 20))
            .navigationBarHidden(true)
            .onAppear {
                if messageFullModel.apiState == .loading{
                    messageFullModel.loadAPI(self.profileID)
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
                        self.showChoosePhoto.toggle()
                        self.showImagePicker = false
                        self.sendMessageMSGMedia(image: image)
                    }
                }
                else{
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        self.showChoosePhoto = false
                        self.showImagePicker = false
                        self.sendMessageMSGMedia(image: image)
                    }
                }
                
            })
            .fullScreenCover(isPresented: $isPresented) {
                       ZStack{
                           SwipingMediaView(mediaItems: [SwipingMediaItem(url: messageFullModel.messages[indexMessage].media,
                                                                          type: .image,
                                                                          shouldShowDownloadButton: false)],
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
    }
    
    func sendMessage(message: String) {
        
        if message.isEmpty{
            return
        }
        UIApplication.shared.endEditing()
        isCallApi = true
        let param = ["sid": Auth.shared.getUserId(), "rid": profileID, "message": message]
        addMessageModel.callApiAddMsg(param) { success in
            withAnimation {
                messageFullModel.loadAPI(self.profileID)
                //messageFullModel.messages.append(self.appendMessageUI(message))
            }
            
            isCallApi = false
            messageText = ""
        }
    }
    
    func sendMessageMSGMedia(image: UIImage) {
        
        UIApplication.shared.endEditing()
        isCallApi = true
        let param = ["sid": Auth.shared.getUserId(), "rid": profileID, "message": ""]
        addMessageModel.callApiMsgMedia(image, param) { success in
            withAnimation {
                messageFullModel.loadAPI(self.profileID)
                //messageFullModel.messages.append(self.appendMessageUI(message))
            }
            
            isCallApi = false
            messageText = ""
        }
    }
    
    private func dateTimeCreateMessage()-> String{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format.string(from: Date())
    }
    
    private func appendMessageUI( _ content: String) -> MessageObj{
       
        let messageObj = MessageObj.init(NSDictionary.init())
        messageObj.id = ""
        messageObj.message = content
        messageObj.created_at = self.dateTimeCreateMessage()
        messageObj.sender_id = Auth.shared.getUserId()
        messageObj.receiver_id = profileID
        return messageObj
    }
    
    private func formatTimeAgo(_ strDate: String)-> String{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        //format.locale = self.getPreferredLocale()
        if let dateS = format.date(from: strDate){
            print(dateS)
            return DateHelper.timeAgoTwoDate(dateS)
        }
        return ""
    }
    
    func delete(at offsets: IndexSet) {
        
    }
}

extension ChatMessageView{
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
                NavigationLink(destination: ProfileView(profileId: self.profileID)) {
                    Text(profileName)
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                .isDetailLink(false)
                
               
            }
            
        )
    }
}
