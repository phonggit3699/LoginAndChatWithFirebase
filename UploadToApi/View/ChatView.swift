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
    @Binding var currentRoom: String
    @State var message: String = ""
    @StateObject var chat = ChatViewModel()
    @State var allMessages: [ChatModel] = []
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    
    
    var body: some View {
        VStack{
            ScrollViewReader { scrollView in
                ScrollView(.vertical, showsIndicators: false, content: {
                    LazyVStack{
                        ForEach(self.allMessages, id: \.self){
                            mgs in
                            ChatMessage(chatMessage: mgs)
                        }
                    }.onChange(of: allMessages, perform: { _ in
                        if(!allMessages.isEmpty){
                            scrollView.scrollTo(allMessages[allMessages.endIndex - 1])
                        }
                    }).onReceive(Publishers.keyboardDidShow, perform: { _ in
                        if(!allMessages.isEmpty){
                            withAnimation(){
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
                            chat.sendMessage(chat: ChatModel(id: nil, name: userID, user: User(id: userID, name: user), message: message, date: Date()), room: currentRoom)
                            self.message = ""
                        }
                    }
                }, label: {
                    Image(systemName: "paperplane.fill")
                })
            }.padding(.horizontal)
        }.onAppear{
            chat.readMessage(room: currentRoom) { value in
                self.allMessages = value
            }
            
        }
        .navigationBarTitle("\(currentRoom)", displayMode: .inline)
    }
}


extension Publishers{
    static var keyboardDidShow: NotificationCenter.Publisher {
        let didShow = NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)
        return didShow
    }
}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(currentRoom: .constant("VIP"))
    }
}

