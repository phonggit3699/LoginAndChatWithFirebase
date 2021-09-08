//
//  ChatMessage.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import SwiftUI

struct ChatMessage: View {
    @AppStorage("userID") var userID = ""
    @Environment(\.scenePhase) private var scenePhase
    var chatMessage: ChatModel
    @EnvironmentObject var storage: StorageViewModel
    
    var body: some View {
        VStack{
            if(chatMessage.user.id == userID){
                HStack{
                    Spacer()
                    Text(chatMessage.message)
                        .padding(.all, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(myMsg: chatMessage.user.id == userID))
                    if storage.profileImage != nil {
                        Image(uiImage: storage.profileImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }else{
                        Circle().fill(Color.gray.opacity(0.8))
                            .frame(width: 30, height: 30)
                    }
                }
                
            }
            if(chatMessage.user.id !=  userID){
                HStack{
                    Image(systemName: "sun.min")
                    Text(chatMessage.message)
                        .padding(.all, 8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(myMsg: chatMessage.user.id == userID))
                    Spacer()
                }
                                
            }
        }.padding(.all, 5)
    }
}

struct ChatMessage_Previews: PreviewProvider {
    static var chatMessage = ChatModel(id: nil, name: "VIP", user: User(id: "12345", name: "Phong"), message: "", date: Date())
    static var allMessages = [ChatModel(id: nil, name: "VIP", user: User(id: "12345", name: "Phong"), message: "", date: Date())]
    
    static var previews: some View {
        ChatMessage(chatMessage: chatMessage).environmentObject(StorageViewModel())
    }
}


