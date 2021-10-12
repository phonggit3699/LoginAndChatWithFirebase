//
//  ChatView.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import SwiftUI
import Combine
import UIKit

struct ChatView: View {
    
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    
    @EnvironmentObject var storage: StorageViewModel
    @State var message: String = ""
    @StateObject var chat = ChatViewModel()
    @State var allMessages: [ChatModel] = []
    @State var isKeyBoardShow: Bool = false
    @State var roomImg: UIImage?
    @Binding var hideTabBar: Bool
    
    var profileImg: UIImage?
    var friendRoom: RoomModel
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            ScrollViewReader { scrollView in
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVStack{
                        ForEach(self.allMessages, id: \.self){
                            mgs in
                            ChatMessage(chatMessage: mgs, profileImg: profileImg, roomImg: roomImg)
                                .id(UUID())
                        }
                    }.onChange(of: allMessages, perform: { _ in
                        if(!allMessages.isEmpty){
                            scrollView.scrollTo(allMessages[allMessages.endIndex - 1])
                        }
                    })
                        .onChange(of: isKeyBoardShow, perform: { _ in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if(!allMessages.isEmpty){
                                    scrollView.scrollTo(allMessages[allMessages.endIndex - 1])
                                }
                            }
                        })
                })
            }.padding(.bottom, 5)
            
            HStack{
                TextField("Aa", text: $message)
                    .font(.system(size: isSmallScreen ? 18 : 20))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 20)
                    .frame(height: isSmallScreen ? 40 : 48)
                    .background(Capsule().fill(Color("lightGray2")))
                
                // button send message
                Button(action: {
                    withAnimation(){
                        if message != "" {
                            let newChat =  ChatModel(id: nil, user: User(id: userID, name: user), message: message, date: Date(), seen: false)
                            chat.sendMessage(chat: newChat, roomId: friendRoom.id)
                            self.message = ""
                        }
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .foregroundColor(Color("mainBg"))
                        .frame(width: isSmallScreen ? 25 : 30, height: isSmallScreen ? 25 : 30)
                })
            }.padding(.horizontal)
            .padding(.bottom, 5)
        }
        .onAppear{
            DispatchQueue.global(qos: .background).async {
                chat.getMessage(roomId: friendRoom.id) { mess in
                    self.allMessages = mess
                }
                
            }
            storage.loadImage(url: friendRoom.roomImgUrl) { img in
                self.roomImg = img
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                self.isKeyBoardShow = true
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.isKeyBoardShow = false
            }
            
        }
        .onDisappear{
            NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
            NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        }
        .navigationBarTitle("\(friendRoom.name)", displayMode: .inline)
        .navigationBarItems(
            leading:
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                DispatchQueue.main.async {
                    hideTabBar = false
                }
            }, label: {
                HStack(spacing: 3){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .font(Font.system(size: 16, weight: .semibold))
                    Text("Chats")
                        .foregroundColor(.blue)
                }
            })
        )
        .navigationBarBackButtonHidden(true)
    }
}


