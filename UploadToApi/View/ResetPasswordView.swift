//
//  ResetPasswordView.swift
//  UploadToApi
//
//  Created by PHONG on 05/08/2021.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var username: String = ""
    @State private var isTabFieldUsername = false
    @Environment (\.presentationMode) var presentationMode
    @EnvironmentObject var auth: AuthViewModel
    var body: some View {
        GeometryReader {proxy in
            ZStack{
                VStack {
                    //username field
                    TextField("Email", text: $username)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.username != "" || self.isTabFieldUsername ? Color.black: Color.gray, lineWidth: 1))
                        .padding(.horizontal)
                        .onTapGesture {
                            self.isTabFieldUsername.toggle()
                        }
                    
                    Button(action: {
                        self.auth.resetPassword(username: username)
                    }, label: {
                        Text("Reset")
                            .foregroundColor(self.username != "" ? Color.black: Color.gray)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(width: 200, height: 50, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
                    }).disabled(self.username == "")
                    .padding(.bottom, 10)
                    
                }
                .frame(width: proxy.size.width / 1.2, height: proxy.size.height / 4, alignment: .center)
                .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
            }.navigationTitle("Reset Password")
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: [Color("lightBlue"), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        .ignoresSafeArea()
        .alert(isPresented: self.$auth.showAlert, content: {
            Alert(title: Text("Reset password"), message: Text("\(self.auth.erorr)"), dismissButton: .cancel(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        })
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView().environmentObject(AuthViewModel())
    }
}