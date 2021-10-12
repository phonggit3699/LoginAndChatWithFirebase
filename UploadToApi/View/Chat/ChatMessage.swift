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
                    VStack(alignment: .trailing, spacing: 0){
                        
                        // Message
                        Text(chatMessage.message)
                            .padding(.all, 8)
                            .background(Color("mainBg"))
                            .foregroundColor(.white)
                            .clipShape(ChatBubble(myMsg: chatMessage.user.id == userID))
                        
                        // Time
                        Text("\(convertDateToHours24(date: chatMessage.date))")
                            .foregroundColor(Color.gray)
                            .font(.caption2)
                    }
                    // Avatar
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
                    // Avatar
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
                    VStack(alignment: .leading, spacing: 0) {
                        // Message
                        Text(chatMessage.message)
                            .padding(.all, 8)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .clipShape(ChatBubble(myMsg: chatMessage.user.id == userID))
                        
                        // Time
                        Text("\(convertDateToHours24(date: chatMessage.date))")
                            .foregroundColor(Color.gray)
                            .font(.caption2)
                    }
                    
                    Spacer()
                }
                                
            }
        }.padding(.all, 5)
    }
}

extension ChatMessage{
    func convertDateToHours24(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

//        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }
}


