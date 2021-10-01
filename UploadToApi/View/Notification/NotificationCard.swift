//
//  NotificationCard.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI
 
struct NotificationCard: View {
    @AppStorage("userID") var userID = ""
    
    var notification: NotificationContent
    
    @ObservedObject var RoomVM = RoomViewModel()
    @ObservedObject var UserVM = UserViewModel()
    
    init(notification: NotificationContent){
        self.notification = notification
    }
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            
            Image("Circle-icons")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            
            
            VStack(alignment: .leading){
                Text(notification.title)
                    .fontWeight(.bold)
                    .foregroundColor( colorScheme == .light ? .black : .white )
                
                Text(notification.message)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                if notification.type == NotificationType.addafriend.rawValue {
                    Button {
                        processAddNewFriend()
                    } label: {
                        Text("Add Friend")
                            .padding(5)
                            .background(Color.green)
                    }

                }
            }
            
            Spacer()
            
        }
    }
}

extension NotificationCard{
    func processAddNewFriend(){
        let newRoomID: String = UUID().uuidString
        
        DispatchQueue.main.async {
            // get profile of this uer
            UserVM.getProfileByID(id: userID) { user in
                // add new common room for this user
                RoomVM.addRoomChat(id: notification.idSend, newRoom: RoomDetailModel(roomID: newRoomID, name: user.name, friendId: user.id, roomImgUrl: user.avatarUrl))
                
                
            }
            
            // get profile of user want to add friend with this uer
            UserVM.getProfileByID(id: notification.idSend) { user in
                // add new common room for user want to add friend with this uer
                RoomVM.addRoomChat(id: userID, newRoom: RoomDetailModel(roomID: newRoomID, name: user.name, friendId: user.id, roomImgUrl: user.avatarUrl))
            }
        }
        
    }
}
