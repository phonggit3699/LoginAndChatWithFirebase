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
    var friendRoom: RoomDetailModel
    @EnvironmentObject var storage: StorageViewModel
    @State var message: String = ""
    @StateObject var chat = ChatViewModel()
    @State var allMessages: [ChatModel] = []
    @State var isKeyBoardShow: Bool = false
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    var profileImg: UIImage?
    @State var roomImg: UIImage?

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
                TextField("", text: $message)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 50)
                Button(action: {
                    withAnimation(){
                        if message != "" {
                            chat.sendMessage(chat: ChatModel(id: nil, name: user, user: User(id: userID, name: user), message: message, date: Date()), room: friendRoom.roomID)
                            self.message = ""
                        }
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
            }.padding(.horizontal)
        }
        .onAppear{
            DispatchQueue.global(qos: .background).async {
                chat.getMessage(room: friendRoom.roomID) { mess in
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
    }
}




struct ChatView_Previews: PreviewProvider {
    static var room = RoomDetailModel(roomID: "dsadsad", name: "VIP")
    static var previews: some View {
        ChatView(friendRoom: room).environmentObject(StorageViewModel())
    }
}
