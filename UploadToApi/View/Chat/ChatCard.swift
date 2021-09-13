//
//  ChatCard.swift
//  UploadToApi
//
//  Created by PHONG on 04/09/2021.
//

import SwiftUI

struct ChatCard: View {
    var room: RoomDetailModel
    @EnvironmentObject var storage: StorageViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var roomImg: UIImage?
    
    init(room: RoomDetailModel){
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
                
                Text("Tap to chat")
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .onAppear{
        
            storage.loadImage(url: room.roomImgUrl) { img in
                self.roomImg = img
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal)
    }
}

struct ChatCard_Previews: PreviewProvider {
    static var previews: some View {
        ChatCard(room: RoomDetailModel(roomID: "", name: "", roomImgUrl: nil)).environmentObject(StorageViewModel())
    }
}
