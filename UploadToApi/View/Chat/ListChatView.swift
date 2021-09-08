//
//  ListChatView.swift
//  UploadToApi
//
//  Created by PHONG on 09/08/2021.
//

import SwiftUI

struct ListChatView: View {
    @AppStorage("userID") var userID = ""
    @State var profileImg: UIImage?
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @ObservedObject var storage = StorageViewModel()
    @EnvironmentObject var auth: AuthViewModel
    @State var showProfile: Bool = false
    @State private var sheetMode: SheetMode = .none
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        ZStack {
            NavigationView{
                VStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        ForEach(exRoom){ room in
                            LazyVStack(spacing: 5){
                                if room.id == userID {
                                    ForEach(room.listRoom, id: \.self){ fRoom in
                                        NavigationLink(
                                            destination: ChatView(friendRoom: fRoom).environmentObject(storage),
                                            label: {
                                                ChatCard(name: fRoom.name)
                                                
                                            })
                                    }
                                }
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: ProfileView().environmentObject(auth).environmentObject(storage),
                        isActive: self.$showProfile,
                        label: {
                            EmptyView()
                        })
                    
                }.onAppear(perform: {
                    storage.getImageProfile(url: self.userPhotoURL)
                    
                })
                .navigationTitle("Chat chit")
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.showProfile.toggle()
                            self.sheetMode = .none
                        }, label: {
                            if storage.profileImage != nil {
                                Image(uiImage: storage.profileImage!)
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
    }
    
}


struct ListChatView_Previews: PreviewProvider {
    static var previews: some View {
        ListChatView().environmentObject(AuthViewModel())
    }
}
