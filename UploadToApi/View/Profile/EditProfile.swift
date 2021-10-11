//
//  EditProfile.swift
//  UploadToApi
//
//  Created by PHONG on 05/09/2021.
//

import SwiftUI

struct EditProfile: View {
    
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserViewModel
    @AppStorage("userID") var userID = ""
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    @Binding var profile: UserModel
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var body: some View {
        
        VStack(spacing: 10){
            HStack{
                Text("Name")
                    .foregroundColor(.gray)
                    .frame(width: 80, alignment: .leading)
                TextField("Name", text: self.$profile.name)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
            }
            
            HStack{
                Text("Phone")
                    .foregroundColor(.gray)
                    .frame(width: 80, alignment: .leading)
                TextField("Phone", text: self.$profile.phone)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
                
            }
            
            HStack{
                Text("Address")
                    .foregroundColor(.gray)
                    .frame(width: 80, alignment: .leading)
                    
                TextField("Address", text: self.$profile.address)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray, lineWidth: 1))
            }
            
            Spacer()
            
            Button(action: {
                let userProfileInput = UserModel(id: self.userID, name: self.profile.name, address: self.profile.address, phone: self.profile.phone, avatarUrl: self.userPhotoURL)
                userModel.postProfile(id: userID,user: userProfileInput)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .foregroundColor(.blue)
            })
            
            Spacer()
        }
        .padding()
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(profile: .constant(UserModel(id: "", name: "", address: "", phone: "", avatarUrl: nil)))
    }
}
