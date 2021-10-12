//
//  NotificationCard.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI

struct NotificationCard: View {
    @AppStorage("userID") var userID = ""
    
    @State private var imageNotification: UIImage?
    
    var notification: NotificationModel
    
    @ObservedObject var RoomVM = RoomViewModel()
    @ObservedObject var UserVM = UserViewModel()
    @EnvironmentObject var NotificationVM: NotifyViewModel
    
    init(notification: NotificationModel){
        self.notification = notification
    }
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            
            ZStack{
                if imageNotification != nil {
                    Image(uiImage: imageNotification!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: isSmallScreen ? 45 : 50, height: isSmallScreen ? 45 : 50)
                }else{
                    Image(systemName: "bell.badge")
                        .resizable()
                        .foregroundColor(.gray)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: isSmallScreen ? 45 : 50, height: isSmallScreen ? 45 : 50)
                        .clipShape(Circle())
                }
            }
            
            VStack(alignment: .leading, spacing: 5){
                Text(notification.title)
                    .fontWeight(.bold)
                    .font(isSmallScreen ? .system(size: 15) : .body)
                    .foregroundColor( colorScheme == .light ? .black : .white )
                
                Text(notification.message)
                    .foregroundColor(.gray)
                    .font(isSmallScreen ? .system(size: 15) : .body)
                    .lineLimit(1)
                
                if notification.type == NotificationType.addfriend.rawValue && notification.isPress == false {
                    HStack{
                        
                        // Accept request
                        Button {
                            // accept add friend
                            processAddNewFriend()
                            
                        } label: {
                            Text("Add Friend")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .font(isSmallScreen ? .system(size: 15) : .body)
                                .padding(5)
                                .padding(.horizontal, 10)
                                .background(Color("mainBg"))
                                .cornerRadius(5)
                        }
                        
                        // Remove request
                        Button {
                            NotificationVM.updateSeenNotification(id: userID, idNotifi: notification.id, message: "Removed request")
                        } label: {
                            Text("Remove")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .font(isSmallScreen ? .system(size: 15) : .body)
                                .padding(5)
                                .padding(.horizontal, 10)
                                .background(Color("lightGray"))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            
            Spacer()
            
        }
        .onAppear{
            NotificationVM.loadNotificationImage(url: notification.imageUrl) { image in
                self.imageNotification = image
            }
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
                let newRoom: RoomModel = RoomModel(id: newRoomID, name: user.name, friendId: user.id, roomImgUrl: user.avatarUrl)
                let backNotification: NotificationModel = NotificationModel(id: UUID().uuidString, title: user.name, message: "Accepted add friend", seen: false, type: NotificationType.normal.rawValue, time: Date(), idSend: user.id, isPress: true, isFriend: true, imageUrl: user.avatarUrl)
                RoomVM.addRoomChat(id: notification.idSend, newRoom: newRoom)
                
                NotificationVM.addNotification(id: notification.idSend, newNotification: backNotification)
                
                
            }
            
            // get profile of user want to add friend with this uer
            UserVM.getProfileByID(id: notification.idSend) { user in
                // add new common room for user want to add friend with this uer
                let newRoom: RoomModel = RoomModel(id: newRoomID, name: user.name, friendId: user.id, roomImgUrl: user.avatarUrl)
                RoomVM.addRoomChat(id: userID, newRoom: newRoom)
            }
            
            NotificationVM.updateSeenNotification(id: userID, idNotifi: notification.id, message: "Accepted request")
        }
        
    }
}
