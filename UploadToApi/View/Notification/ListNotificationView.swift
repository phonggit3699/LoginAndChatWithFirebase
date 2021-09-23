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
    
    @State private var notification: NoticationModel?
    
    
    var body: some View {
        VStack{
            Button {
                guard var allNoti = notification?.content else{
                    return
                }
                    
                let newNoti = NotificationVM.createNotifycation(title: "Test 2", message: "Anh ban be", seen: false, type: "normal", time: Date())
                allNoti.append(newNoti)
                
                NotificationVM.updateNewNotification(notification: NoticationModel(id: userID, content: allNoti))
                
            } label: {
                Text("Add new Noti")
            }

        }.onAppear{
            
            NotificationVM.getNotification(id: userID) {value in
                self.notification = value
            }
        }
        .onDisappear{
            if let noti = notification {
                let seenNoti = noti.content.map { value in
                    return NotificationContent (title: value.title, message: value.message, seen: true, type: value.type, time: value.time)
                }
                
                NotificationVM.updateNewNotification(notification: NoticationModel(id: userID, content: seenNoti))
            }
        }
    }
}

struct ListNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ListNotificationView(NotificationVM: NotifyViewModel())
    }
}
