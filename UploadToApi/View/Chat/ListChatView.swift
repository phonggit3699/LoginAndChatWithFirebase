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
                            
                            Button {
                                selectedRoom = fRoom
                                isActive.toggle()
                                DispatchQueue.main.async {
                                    hideTabBar = true
                                }
                            } label: {
                                ChatCard(room: fRoom).environmentObject(storage)
                            }
                            
                            
                        }
                    }
                    
                }
                if selectedRoom != nil{
                    NavigationLink(
                        destination: ChatView(hideTabBar: $hideTabBar, profileImg: self.profileImg, friendRoom: selectedRoom!).environmentObject(storage),
                        isActive: $isActive,
                        label: {
                            EmptyView()
                            
                        })
                }
            }
            
        }
        .padding(.top)
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
