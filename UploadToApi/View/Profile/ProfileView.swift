//
//  ProfileView.swift
//  UploadToApi
//
//  Created by PHONG on 04/08/2021.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @AppStorage("currentUser") var user = ""
    
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var storage = StorageViewModel()
    @ObservedObject var userModel = UserViewModel()
    @ObservedObject var notificationVM = NotifyViewModel()
    @ObservedObject var roomVM = RoomViewModel()
    
    @State var editProfile: Bool = false
    @State var showImagePicker = false
    @State var userProfile: UserModel = UserModel(id: "", name: "", address: "", phone: "", avatarUrl: nil)
    @State var showActionSheet: Bool = false
    @State var profileImg: UIImage?
    
    @Binding var hideTabBar: Bool
    var idSearchResult: String?
    
    @Environment (\.presentationMode) var presentationMode
    
    init(idSearchResult: String?, hideTabBar: Binding<Bool>){
        self.idSearchResult = idSearchResult
        _hideTabBar = hideTabBar
    }
    
    var body: some View {
        
        // TODO: Info user
        VStack{
            ScrollView(.vertical, showsIndicators: false, content: {
                
                //TODO: Avatar component
                ZStack {
                    VStack{
                        Spacer()
                        Text("Change")
                            .font(.caption)
                    }
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenSize().width / 4)
                    
                    if profileImg != nil {
                        Image(uiImage: profileImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    
                }
                .frame(width: screenSize().width / 2, height: screenSize().width / 2, alignment: .center)
                .background(Circle().stroke(Color.gray))
                .onTapGesture {
                    self.showImagePicker.toggle()
                }
                
                //TODO: Detail profile component
                VStack(spacing: 20){
                    Text("\(self.userProfile.name)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Address \(self.userProfile.address)")
                        .foregroundColor(.gray)
                    
                    Text("Phone \(self.userProfile.phone)")
                        .foregroundColor(.gray)
                }
                // check result of search to hide button logout and show button add friend
                if idSearchResult == nil {
                    Button(action: {
                        self.showActionSheet.toggle()
                      
                    }, label: {
                        Text("Log out")
                            .foregroundColor(Color.red)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Rectangle().stroke(Color.gray, lineWidth: 1))
                    }).padding()
                }else{
                    ZStack{
                        if roomVM.isFriend == true {
                            Text("Friend")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("mainBg"))
                        }else{
                            Button(action: {
                                let newNotifi = NotificationModel(id: UUID().uuidString,title: user, message: "Friend request", seen: false, type: NotificationType.addafriend.rawValue, time: Date(), idSend: userID, isPress: false, isFriend: false, imageUrl: userPhotoURL)
                                notificationVM.addNotification(id: idSearchResult!, newNotification: newNotifi)
                                roomVM.isPending.toggle()
                            }, label: {
                                Text(roomVM.isPending == true ? "Pending" : "Add friend")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .padding(.horizontal, 10)
                                    .background(Color("mainBg"))
                                    .cornerRadius(5)
                            })
                            .padding()
                            .disabled(roomVM.isPending)
                        }
                    }
                }
                
            })
            
            NavigationLink(
                destination: EditProfile(profile: self.$userProfile).environmentObject(userModel),
                isActive: self.$editProfile,
                label: {
                    EmptyView()
                })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .toolbar(content: {
            if idSearchResult == nil {
                Button(action: {
                    self.editProfile.toggle()
                }, label: {
                    Image(systemName: "square.and.pencil")
                })
            }
        })
        .sheet(isPresented: self.$showImagePicker, onDismiss: {}, content: {
            ImagePicker(image: $profileImg).environmentObject(storage)
        })
        .actionSheet(isPresented: $showActionSheet, content: {
            let logout = ActionSheet.Button.default(Text("Logout")) {
                self.auth.logout()
                self.presentationMode.wrappedValue.dismiss()
                self.hideTabBar = false
            }
            
            let cancel = ActionSheet.Button.cancel(Text("Cancel")) {
                showActionSheet = false
            }
            
            
            return ActionSheet(title: Text("Are you sure to log out?"), message: nil, buttons: [logout, cancel])
        })
        .onAppear{
            if idSearchResult != nil {
                userModel.getProfileByID(id: idSearchResult!) { profile in
                    self.userProfile = profile
                    self.storage.getImageProfile(url: userProfile.avatarUrl) { value in
                        self.profileImg = value
                    }
                }
                
                roomVM.friendCheck(otherId: idSearchResult!)
            }
            else if userID != ""{
                userModel.getProfileByID(id: userID) { profile in
                    self.userProfile = profile
                    self.storage.getImageProfile(url: userProfile.avatarUrl) { value in
                        self.profileImg = value
                    }
                }
            }
            
            
        }
        .navigationTitle("Profile")
        .navigationBarItems(
            leading:
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.async {
                        hideTabBar = false
                    }
                }, label: {
                    HStack(spacing: 3){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .font(Font.system(size: 16, weight: .semibold))
                        Text("\(idSearchResult != nil ? "Search" : "Home")")
                            .foregroundColor(.blue)
                    }
                })
        )
        .navigationBarBackButtonHidden(true)
    }
    
}

extension ProfileView {
    func screenSize() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(idSearchResult: nil, hideTabBar: .constant(false)).environmentObject(AuthViewModel())
    }
}

//                Button(action: {
//                    let userProfileInput = UserModel(id: self.userID, name: "Phong", address: "HaiDUong", phone: 123456)
//
//                    userModel.postProfile(user: userProfileInput)
//
//                    print("submit")
//                }, label: {
//                    Text("Submit")
//                        .foregroundColor(Color.gray)
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .padding()
//                        .frame(width: 200, height: 50, alignment: .center)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
//                })
