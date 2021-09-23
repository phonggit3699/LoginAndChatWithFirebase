//
//  ListChatView.swift
//  UploadToApi
//
//  Created by PHONG on 09/08/2021.
//

import SwiftUI

struct ListChatView: View {
    @AppStorage("userID") var userID = ""
    
    @ObservedObject var storage: StorageViewModel
    @StateObject var roomModel = RoomViewModel()
    
    @Binding var profileImg: UIImage?
    @State private var room: RoomModel?
    @State var isActive: Bool = false
    @Binding var hideTabBar: Bool
    @State var selectedRoom: RoomDetailModel?
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 5){
                    if room != nil {
                        ForEach(room!.listRoom, id: \.self){ fRoom in
//                            NavigationLink(
//                                destination: ChatView(friendRoom: fRoom, profileImg: self.profileImg).environmentObject(storage),
//                                isActive: $isActive,
//                                label: {
//                                    ChatCard(room: fRoom).environmentObject(storage)
//
//                                })
                            Button {
                                selectedRoom = fRoom
                                isActive.toggle()
                            } label: {
                                ChatCard(room: fRoom).environmentObject(storage)
                            }

                        
                        }
                    }
                    
                }
                if selectedRoom != nil{
                    NavigationLink(
                        destination: ChatView(friendRoom: selectedRoom!, profileImg: self.profileImg).environmentObject(storage),
                        isActive: $isActive,
                        label: {
                            EmptyView()
                            
                        })
                }
            }
            
        }.padding(.top)
        .onChange(of: isActive, perform: { value in
            hideTabBar = isActive
        })
        .onAppear(perform: {
            roomModel.getRoomLocal { room in
                self.room = room
            }
            
            roomModel.getRoomChat(id: userID) { roomData in
                self.room = roomData
            }
            
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
        ListChatView(storage: StorageViewModel(), profileImg: .constant(nil), hideTabBar: .constant(false)).environmentObject(AuthViewModel())
    }
}
