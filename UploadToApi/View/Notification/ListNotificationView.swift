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
    
    @State private var notifications: [NotificationModel]?
    
    
    var body: some View {
        
        VStack{
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 5){
                    if notifications != nil {
                        ForEach(notifications!, id: \.self){ noti in
                            Button {
                                print("navigate")
                            } label: {
                                NotificationCard(notification: noti).environmentObject(NotificationVM)
                            }


                        }
                    }

                }
            }

        }.padding()
        .onAppear{
            if userID != "" {
                NotificationVM.getNotification(id: userID) { notificationDatas in
                    self.notifications = notificationDatas
                }
            }  
        }
    }
}

struct ListNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ListNotificationView(NotificationVM: NotifyViewModel())
    }
}
