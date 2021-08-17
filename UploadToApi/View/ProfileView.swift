//
//  ProfileView.swift
//  UploadToApi
//
//  Created by PHONG on 04/08/2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @ObservedObject var storage = StorageViewModel()
    @ObservedObject var userModel = UserViewModel()
    @State var profileImg: UIImage?
    @State var showImagePicker = false
    @AppStorage("currentUser") var user = ""
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @State var userProfile: UserModel?
    
    var body: some View {
        GeometryReader{proxy in
            let size = proxy.size
            VStack{
                ZStack {
                    VStack{
                        Spacer()
                        Text("Change")
                            .font(.caption)
                    }
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.width / 4)
                    
                    if profileImg != nil {
                        Image(uiImage: profileImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    
                }
                .frame(width: size.width / 3, height: size.width / 3, alignment: .center)
                .background(Circle().stroke(Color.gray))
                .onTapGesture {
                    self.showImagePicker.toggle()
                }
                HStack{
                    Text("\(self.user)")
                    
                }
                Spacer()
                
                Button(action: {
                    let userProfileInput = UserModel(id: self.userID, name: "Phong", address: "HaiDUong", phone: 123456)
                    
                    userModel.postProfile(user: userProfileInput)
                    
                    print("submit")
                }, label: {
                    Text("Submit")
                        .foregroundColor(Color.gray)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
                })
                
                Button(action: {
                    auth.logout()
                }, label: {
                    Text("Log out")
                        .foregroundColor(Color.gray)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
                })
            }
            .frame(width: size.width, height: size.height)
            .sheet(isPresented: self.$showImagePicker, onDismiss: {}, content: {
                ImagePicker(image: self.$profileImg).environmentObject(storage)
            })
            .onAppear(perform: {
                if let url = userPhotoURL{
                    storage.loadImage(url: url) { data in
                        profileImg = data
                    }
                }else{
                    storage.downloadProfileImage { image in
                        self.profileImg = image
                    }
                }
                userModel.getProfileByID(id: self.userID) { data in
                    if !data.isEmpty{
                        self.userProfile = data[0]
                        print(data[0])
                    }
                }
                
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}

