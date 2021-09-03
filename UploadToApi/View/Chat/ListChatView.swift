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
                    List(){
                        Section(header: Text("VIP")) {
                            ForEach(exRoom){ room in
                                if room.id == userID {
                                    ForEach(room.listRoom, id: \.self){ fRoom in
                                        NavigationLink(
                                            destination: ChatView(friendRoom: fRoom),
                                            label: {
                                                Text(fRoom.name)
                                                
                                            })
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: ProfileView().environmentObject(auth),
                        isActive: self.$showProfile,
                        label: {
                            EmptyView()
                        })
                    
                }.onAppear(perform: {
                    self.profileImg = UIImage(systemName: "person.crop.circle")
                    if let url = userPhotoURL{
                        storage.loadImage(url: url) { data in
                            profileImg = data
                        }
                    }else{
                        storage.downloadProfileImage { image in
                            self.profileImg = image
                        }
                    }
                    
                })
                .navigationTitle("Chat chit")
                .navigationBarItems(
                    leading:
                        Button(action: {
                            self.showProfile.toggle()
                        }, label: {
                            if profileImg != nil {
                                Image(uiImage: profileImg!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
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
                VStack {
                    ZStack {
                        Capsule()
                            .fill(self.colorScheme == .dark ? Color.white : Color.gray)
                            .frame(width: 40, height: 8)
                            .padding(.vertical, 5)
                            .gesture(DragGesture().onChanged({ value in
                                if (value.translation.height < 0){
                                    
                                    sheetMode = .full
                                }else {
                                    sheetMode = .none
                                }
                            })
                            .onEnded({ value in
                                if (value.translation.height < 0){
                                    
                                    sheetMode = .full
                                }else {
                                    sheetMode = .none
                                }
                            }))
                        
                        HStack {
                            Button(action: {
                                sheetMode = .none
                            }, label: {
                                Text("Cancel")
                            })
                            Spacer()
                            
                            Button(action: {
                                sheetMode = .none
                            }, label: {
                                Text("Done")
                            })
                        }.padding(.vertical, 10)
                        .padding(.horizontal, 15)
                    }
                    
                    Spacer()
                    
                    Text("Setting")
                        .foregroundColor(.black)
                    Button(action: {
                        sheetMode = .none
                    }, label: {
                        Text("Cancel")
                    })
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("darkSheet"))
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
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
