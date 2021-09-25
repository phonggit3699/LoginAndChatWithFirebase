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
    
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var storage: StorageViewModel
    @ObservedObject var userModel = UserViewModel()
    @State var editProfile: Bool = false
    @State var showImagePicker = false
    
    @State var userProfile: UserModel = UserModel(id: "", name: "", address: "", phone: "", avatarUrl: nil)
    @State var showActionSheet: Bool = false
    @State var profileImg: UIImage?
    
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
                VStack{
                    Text("\(self.userProfile.name)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Address \(self.userProfile.address)")
                        .foregroundColor(.gray)
                    
                    Text("Phone \(self.userProfile.phone)")
                        .foregroundColor(.gray)
                }
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
            Button(action: {
                self.editProfile.toggle()
            }, label: {
                Image(systemName: "square.and.pencil")
            })
        })
        .sheet(isPresented: self.$showImagePicker, onDismiss: {}, content: {
            ImagePicker(image: $profileImg).environmentObject(storage)
        })
        .navigationTitle("Profile")
        .actionSheet(isPresented: $showActionSheet, content: {
            let logout = ActionSheet.Button.default(Text("Logout")) {
                self.auth.logout()
            }
            
            let cancel = ActionSheet.Button.cancel(Text("Cancel")) {
                showActionSheet = false
            }
            
            
            return ActionSheet(title: Text("Are you sure to log out?"), message: nil, buttons: [logout, cancel])
        })
        .onAppear{
            if userID != ""{
                userModel.getProfileByID(id: userID) { profile in
                    self.userProfile = profile
                }
            }
        }
    }
    
}

extension ProfileView {
    func screenSize() -> CGRect {
        return UIScreen.main.bounds
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
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
