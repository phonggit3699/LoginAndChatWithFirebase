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
    @State var profileImg: UIImage?
    @State var showImagePicker = false
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
                    Text("\(auth.auth.currentUser?.displayName ?? "None")")
                    
                }
                Spacer()
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
            .sheet(isPresented: self.$showImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: self.$profileImg).environmentObject(storage)
            })
            .onAppear(perform: {
                storage.downloadProfileImage { image in
                    self.profileImg = image
                }
            })
        }
    }
}
extension ProfileView {
    func loadImage() {
        print("run")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}

