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
    @EnvironmentObject var auth: AuthViewModel
    @State var profileImg: UIImage?
    @State var room: RoomModel?
    @State var showProfile: Bool = false
    @State private var sheetMode: SheetMode = .none
    @Environment(\.colorScheme) var colorScheme
    
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
                    
                    NavigationLink(
                        destination: ProfileView(profileImg: self.profileImg).environmentObject(auth).environmentObject(storage),
                        isActive: self.$showProfile,
                        label: {
                            EmptyView()
                        })
                    
                }
                .navigationTitle("Chat chit")
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.showProfile.toggle()
                            self.sheetMode = .none
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
                        Button(action: {
                            if sheetMode == .half || sheetMode == .full {
                                sheetMode = .none
                            }else{
                                sheetMode = .half
                            }
                        }, label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .foregroundColor(self.colorScheme == .dark ? .white : .black)
                                .clipShape(Circle())
                                .frame(width: 25, height: 25)
                        }))
            }
            .zIndex(1)
            FlexibleSheet(sheetMode: $sheetMode) {
                SettingView()
            }
            .zIndex(2)
        }
        .onAppear(perform: {
            roomModel.getRoomChat(id: userID) { roomData in
                self.room = roomData
            }
            storage.getImageProfile(url: userPhotoURL) { image in
                self.profileImg = image
            }
        })
    }
    
}


struct ListChatView_Previews: PreviewProvider {
    static var previews: some View {
        ListChatView().environmentObject(AuthViewModel())
    }
}
