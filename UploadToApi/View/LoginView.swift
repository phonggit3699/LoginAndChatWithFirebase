//
//  LoginView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword = false
    @State private var isCreateAccount = false
    @State private var isResetPassword = false
    @State private var isTabFieldUsername = false
    @State private var isTabFieldPassword = false
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        NavigationView{
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
                                self.isTabFieldPassword = false
                            }

                        // Password field
                        ZStack{
                            if self.showPassword {
                                TextField("Password", text: $password)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" || self.isTabFieldPassword ? Color.black: Color.gray, lineWidth: 1))
                                    .onTapGesture {
                                        self.isTabFieldPassword.toggle()
                                        self.isTabFieldUsername = false
                                    }
                            }else{
                                SecureField("Password", text: $password)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password !=  "" || self.isTabFieldPassword ? Color.black: Color.gray, lineWidth: 1))
                                    .onTapGesture {
                                        self.isTabFieldPassword.toggle()
                                        self.isTabFieldUsername = false
                                    }
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showPassword.toggle()
                                }, label: {
                                    Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(self.password != "" || self.isTabFieldPassword ? Color.black: Color.gray)
                                }).padding(.trailing, 5)
                            }
                        }.padding([.horizontal,.top])
                        
                        Button(action: {
                            self.isCreateAccount.toggle()
                        }, label: {
                            Text("Create the acccount")
                        }).padding(.vertical)
                        
                        NavigationLink(
                            destination: SignInView(),
                            isActive: self.$isCreateAccount,
                            label: {
                                EmptyView()
                            })
                        
                        Button(action: {
                            self.auth.login(email: self.username, password: self.password)
                        }, label: {
                            Text("Login")
                                .foregroundColor(self.password != "" && self.username != "" ? Color.black: Color.gray)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color("lightBlue")))
                        }).disabled(self.password == "" || self.username == "")
                        .padding(.bottom, 10)
                        
                        Button(action: {
                            auth.sighInWithGoogle()
                        }, label: {
                            ZStack {
                                HStack(alignment: .center) {
                                    Image("google")
                                        .resizable()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .padding(.leading, 5)
                                    Spacer()
                                    
                                }
                                Text("Continue with Google")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding()
                            }.background(Color.white.cornerRadius(3))
                            
                            
                        }).padding()
                        .frame(height: 60)
                        
                        LoginFBButton()
                            .padding(.horizontal)
                            .frame(height: 50)
                            .environmentObject(auth)
                        
                        NavigationLink(
                            destination: ResetPasswordView().environmentObject(auth),
                            isActive: self.$isResetPassword,
                            label: {
                                EmptyView()
                            })
                        
                        Button(action: {
                            self.isResetPassword.toggle()
                        }, label: {
                            Text("Forgot password")
                        }).padding(.top)
                        
                    }
                    .frame(width: proxy.size.width / 1.2, height: proxy.size.height / 2, alignment: .center)
                    .background(Color.white.opacity(0.2).clipShape(RoundedRectangle.init(cornerRadius: 15)))
                }.navigationTitle("Login")
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color("lightBlue"), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .alert(isPresented: self.$auth.showAlert, content: {
                    Alert(title: Text("Erorr"), message: Text("\(self.auth.erorr)"), dismissButton: .default(Text("OK")))
                })
            }
            .ignoresSafeArea()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthViewModel())
    }
}