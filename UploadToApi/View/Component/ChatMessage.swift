//
//  ChatMessage.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import SwiftUI

struct ChatMessage: View {
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @ObservedObject var storage = StorageViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State var profileImg: UIImage?
    var chatMessage: ChatModel
    
    var body: some View {
        VStack{
            if(chatMessage.user.name == user){
                HStack{
                    Spacer()
                    Text(chatMessage.message)
                        .padding(.all, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(myMsg: chatMessage.user.name == user))
                    if profileImg != nil {
                        Image(uiImage: profileImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }
                }
                
            }
            if(chatMessage.user.name != user){
                HStack{
                    Image(systemName: "sun.min")
                    Text(chatMessage.message)
                        .padding(.all, 8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .clipShape(ChatBubble(myMsg: chatMessage.user.name == user))
                    Spacer()
                }
                                
            }
        }.padding(.all, 5)
        .onAppear{
            if let url = userPhotoURL{
                storage.loadImage(url: url) { data in
                    profileImg = data
                }
            }else{
                storage.downloadProfileImage { image in
                    self.profileImg = image
                }
            }
        }
    }
}

struct ChatMessage_Previews: PreviewProvider {
    static var chatMessage = ChatModel(id: nil, name: "VIP", user: User(id: nil, name: "Phong"), message: "", date: Date())
    static var allMessages = [ChatModel(id: nil, name: "VIP", user: User(id: nil, name: "Phong"), message: "", date: Date())]
    static var previews: some View {
        ChatMessage(chatMessage: chatMessage)
    }
}


