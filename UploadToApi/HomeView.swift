//
//  ContentView.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @AppStorage("userID") var userID = ""
    @AppStorage("rememberMe") var rememberMe = false
    @AppStorage("userPhotoURL") var userPhotoURL: URL?
    
    @StateObject var authVM = AuthViewModel()
    @StateObject var NotificationVM = NotifyViewModel()
    @StateObject var storageVM = StorageViewModel()
    @State private var profileImg: UIImage?
    @State private var showSheet: Bool = false
    @State private var selecttionTab: String = "New Feed"
    @State private var hideTabBar: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack{
            if self.authVM.isLogin {
                ZStack{
                    NavigationView{
                        
                        TabView(selection: $selecttionTab) {
                            ListChatView(storage: storageVM, profileImg: $profileImg, hideTabBar: $hideTabBar)
                                .environmentObject(authVM)
                                .tag("Chats")
                            
                            NewFeedView()
                                .tag("New Feed")
                            
                            ListNotificationView(NotificationVM: NotificationVM)
                                .tag("Notifications")
                            
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .navigationTitle(selecttionTab)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            leading:
                                //Show profile view
                                //Navigate to ProfileView
                                NavigationLink(
                                    destination: ProfileView(auth: authVM, profileImg: self.profileImg),
                                    label: {
                                        if profileImg != nil {
                                            Image(uiImage: profileImg!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 30, height: 30)
                                        }else{
                                            Circle().fill(Color.gray.opacity(0.8))
                                                .frame(width: 30, height: 30)
                                        }
                                        
                                    })
                            ,
                            trailing:
                                
                                //Show setting
                                Button(action: {
                                    showSheet.toggle()
                                }, label: {
                                    Image(systemName: "gearshape")
                                        .resizable()
                                        .foregroundColor(self.colorScheme == .dark ? .white : .black)
                                        .clipShape(Circle())
                                        .frame(width: 25, height: 25)
                                })
                        )
                        
                    }
                    //Custom Tab Bar
                    .overlay(
                        CustomTabViewBar(selectionTab: $selecttionTab)
                            .environmentObject(NotificationVM)
                            .opacity( hideTabBar == true || self.authVM.isLogin == false ? 0 : 1 )
                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                        
                        ,alignment: .bottom
                    )
                    //Custom bottom sheet
                    FlexibleSheet(showSheet: $showSheet) {
                        SettingView()
                    }.zIndex(2)
                }
                
            }else{
                LoginView().environmentObject(authVM)
                    .transition(.move(edge: .leading))
            }
        }
        .onAppear{
            authVM.onAppear()
            NotificationVM.countNotification(id: userID)
            
            storageVM.getImageProfile(url: userPhotoURL) { image in
                self.profileImg = image
            }
            
        }
        .alert(isPresented: $authVM.showAlert) {
            Alert(title: Text("Hey"), message: Text("Do you want save account"), primaryButton: .default(Text("Save"), action: {
                rememberMe = true
                
            }), secondaryButton: .destructive(Text("Cancel")))
        }
        .onChange(of: showSheet) { value in
            hideTabBar = value
        }
        
        
    }
}

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


