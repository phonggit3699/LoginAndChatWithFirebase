//
//  ChatMessage.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import SwiftUI

struct ChatMessage: View {
    @AppStorage("userID") var userID = ""
    var chatMessage: ChatModel
    var profileImg: UIImage?
    var roomImg: UIImage?
    
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
                    if profileImg != nil {
                        Image(uiImage: profileImg!)
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
                    if roomImg != nil {
                        Image(uiImage: roomImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    }else{
                        Circle().fill(Color.gray.opacity(0.8))
                            .frame(width: 30, height: 30)
                    }
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


