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
    @ObservedObject var userVM = UserViewModel()
    
    @State private var profileImg: UIImage?
    @State private var showSheet: Bool = false
    @State private var selecttionTab: String = "New Feed"
    @State var hideTabBar: Bool = false
    @State private var hideNavBar: Bool = false
    @State private var isActive: Bool = false
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack{
            if authVM.isLogin == false {
                
                LoginView().environmentObject(authVM)
                    .transition(.move(edge: .leading))
            }else{
                ZStack{
                    NavigationView{
                        
                        TabView(selection: $selecttionTab) {
                            
                            NewFeedView(avatarImg: $profileImg)
                                .tag("New Feed")
                            
                            ListChatView(storage: storageVM, profileImg: $profileImg, hideTabBar: $hideTabBar)
                                .environmentObject(authVM)
                                .tag("Chats")
                            
                            ListNotificationView(NotificationVM: NotificationVM)
                                .tag("Notifications")
                            
                            SearchView(hideTabBar: $hideTabBar)
                                .tag("Search")
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .navigationTitle(selecttionTab)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(
                            leading:
                                ZStack{
                                    //Show profile view
                                    Button(action: {
                                        hideTabBar.toggle()
                                        isActive.toggle()
                                    }, label: {
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
                                    
                                    //Navigate to ProfileView
                                    NavigationLink(
                                        destination:
                                            ProfileView(idSearchResult: nil, hideTabBar: $hideTabBar).environmentObject(authVM),
                                        isActive: $isActive)
                                    {
                                        EmptyView()
                                    }
                                    
                                }
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
                .transition(.move(edge: .trailing))
                .onAppear{
                    
                    // setup for push notification
                    NotificationVM.setUpPushNotificationLocal()
                    
                    if userID != "" {
                        
                        NotificationVM.countNotification(id: userID)
                        
                        storageVM.getImageProfile(url: userPhotoURL) { image in
                            self.profileImg = image
                        }
                        
                        userVM.checkUser(id: userID)
                        
                    }else {
                        authVM.logout()
                    }
                    
                    hideTabBar = false
                    
                }
                .onChange(of: NotificationVM.countNewNotification, perform: { newValue in
                    if newValue > 0 {
                        NotificationVM.createNotificationLocal(title: "Test", subTitle: "Test")
                    }
                })
                .onChange(of: showSheet) { value in
                    hideTabBar = value
                }
                .alert(isPresented: $authVM.showAlert) {
                    Alert(title: Text("Hey"), message: Text("Do you want save account"), primaryButton: .default(Text("Save"), action: {
                        rememberMe = true
                        
                    }), secondaryButton: .destructive(Text("Cancel")))
                }
            }
        }
        .onAppear{
            //check authentication
            authVM.onAppear()
        }
    }
}

struct HomeViewPreviews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


