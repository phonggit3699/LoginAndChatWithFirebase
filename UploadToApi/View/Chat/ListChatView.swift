//
//  ListChatView.swift
//  UploadToApi
//
//  Created by PHONG on 09/08/2021.
//

import SwiftUI

struct ListChatView: View {
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @ObservedObject var storage = StorageViewModel()
    @ObservedObject var roomModel = RoomViewModel()
    @StateObject var NotificationVM = NotifyViewModel()
    @EnvironmentObject var auth: AuthViewModel
    @State private var profileImg: UIImage?
    @State private var room: RoomModel?
    @State private var showProfile: Bool = false
    @State private var showSheet: Bool = false
    @State private var showSpinner: Bool = false
    @State private var showNotification: Bool = false
    @State var countNewNotification: Int = 0
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        
        ZStack {
            NavigationView{
                VStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 5){
                            if room != nil {
                                ForEach(room!.listRoom, id: \.self){ fRoom in
                                    NavigationLink(
                                        destination: ChatView(friendRoom: fRoom, profileImg: self.profileImg).environmentObject(storage),
                                        label: {
                                            ChatCard(room: fRoom).environmentObject(storage)
                                            
                                        })
                                }
                            }
                                                    
                        }
                    }
                    
                    //Navigate to ProfileView
                    NavigationLink(
                        destination: ProfileView(profileImg: self.profileImg).environmentObject(auth).environmentObject(storage),
                        isActive: self.$showProfile,
                        label: {
                            EmptyView()
                        })
                    
                    //Navigate to NotificationView
                    NavigationLink(
                        destination: ListNotificationView(countNewNotification: $countNewNotification),
                        isActive: $showNotification,
                        label: {
                            EmptyView()
                        })
                    
                }
                .navigationTitle("Chat chit")
                .navigationBarItems(
                    leading:
                        
                        //Show profile view
                        Button(action: {
                            self.showProfile.toggle()
                            showSheet = false
                        }, label: {
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
                            
                        }),
                    trailing:
                        
                        HStack(spacing: 15){
                            
                            //Show notification
                            ZStack(alignment: .topTrailing){
                                Button(action: {
                                    showNotification.toggle()
                                }, label: {
                                    Image(systemName: "bell")
                                        .resizable()
                                        .foregroundColor(self.colorScheme == .dark ? .white : .black)
                                        .clipShape(Circle())
                                        .frame(width: 25, height: 25)
                                })
                                
                                if NotificationVM.countNewNoti > 0 {
                                    Text(String(NotificationVM.countNewNoti))
                                        .foregroundColor(.white)
                                        .font(.system(size: 10))
                                        .padding(5)
                                        .background(Color.red)
                                        .frame(width: 15, height: 15)
                                        .clipShape(Circle())
                                        .offset(y: -2)
                                }
                            }
                          
                            
                            //Show setting
                            Button(action: {
                                showSheet.toggle()
                            }, label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
                                    .clipShape(Circle())
                                    .frame(width: 25, height: 25)
                            })
                        })
                        
            }
            .zIndex(1)
            FlexibleSheet(showSheet: $showSheet) {
                SettingView()
            }
            .zIndex(2)
            
            if showSpinner {
                
            }
        }
        .onAppear(perform: {
            roomModel.getRoomLocal { room in
                self.room = room
            }
            
            roomModel.getRoomChat(id: userID) { roomData in
                self.room = roomData
            }
            storage.getImageProfile(url: userPhotoURL) { image in
                self.profileImg = image
            }
            
            NotificationVM.countNotification(id: userID)
        })
        .onChange(of: scenePhase) { value in
            if scenePhase == .background || scenePhase == .inactive {
                if let room = self.room {
                    roomModel.saveRoom(room: room)
                }
                
            }
        }
    }
    
}


struct ListChatView_Previews: PreviewProvider {
    static var previews: some View {
        ListChatView().environmentObject(AuthViewModel())
    }
}
