//
//  ChatCard.swift
//  UploadToApi
//
//  Created by PHONG on 04/09/2021.
//

import SwiftUI

struct ChatCard: View {
    var room: RoomModel
    @EnvironmentObject var storage: StorageViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var roomImg: UIImage?
    @ObservedObject var chat = ChatViewModel()
    @State var lastMessage: String = ""
    @AppStorage("userID") var userID = ""
    
    init(room: RoomModel){
        self.room = room
    }
    
    var body: some View {
        HStack(spacing: 10){
            ZStack(alignment: .bottomTrailing){
                if roomImg != nil {
                    Image(uiImage: roomImg!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    
                }else{
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                }
                ZStack{
                    Circle()
                        .stroke( colorScheme == .light ? Color.white : Color.black, lineWidth: 3)
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                }.offset(x: -1, y: -1)
            }
            VStack(alignment: .leading){
                Text(room.name)
                    .fontWeight(.bold)
                    .foregroundColor( colorScheme == .light ? .black : .white )
                
                Text(lastMessage)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
        }
        .onAppear{
            
            storage.loadImage(url: room.roomImgUrl) { img in
                self.roomImg = img
            }
            
            chat.getLastMessage(roomId: room.id) { mgs in
                if mgs.isEmpty == false {
                    if mgs[0].user.id == userID {
                        self.lastMessage = "You: " + mgs[0].message
                    }else{
                        self.lastMessage = mgs[0].message
                    }
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal)
    }
}

