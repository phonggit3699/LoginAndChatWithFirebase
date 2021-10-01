//
//  ListNotificationView.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import SwiftUI

struct ListNotificationView: View {
    @AppStorage("userID") var userID = ""
    
    @ObservedObject var NotificationVM: NotifyViewModel
    
    @State private var notification: NotificationModel?
    
    
    var body: some View {
        
        VStack{
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 5){
                    if notification != nil {
                        ForEach(notification!.content){ noti in
                            Button {
                                print("navigate")
                            } label: {
                                NotificationCard(notification: noti)
                            }

                        
                        }
                    }
                    
                }
//                if selectedRoom != nil{
//                    NavigationLink(
//                        destination: ChatView(friendRoom: selectedRoom!, profileImg: self.profileImg).environmentObject(storage),
//                        isActive: $isActive,
//                        label: {
//                            EmptyView()
//
//                        })
//                }
            }

        }.padding()
        .onAppear{
            if userID != ""{
                NotificationVM.getNotification(id: userID) {value in
                    self.notification = value
                }
            }
        }
        .onDisappear{
            if let notification  = notification {
                let seenNotification = notification.content.map { value in
                    return NotificationContent (title: value.title, message: value.message, seen: true, type: value.type, time: value.time, idSend: userID)
                }
                
                NotificationVM.updateSeenNotification(id: userID, notification: NotificationModel(id: userID, content: seenNotification))
            }
        }
    }
}

struct ListNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ListNotificationView(NotificationVM: NotifyViewModel())
    }
}
