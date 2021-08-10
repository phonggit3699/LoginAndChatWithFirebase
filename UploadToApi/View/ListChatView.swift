//
//  ListChatView.swift
//  UploadToApi
//
//  Created by PHONG on 09/08/2021.
//

import SwiftUI

struct ListChatView: View {
    @State var currentRoom: String = ""
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView{
            List(){
                Section(header: Text("VIP")) {
                    
                    NavigationLink(
                        destination: ChatView(currentRoom: $currentRoom),
                        isActive: $isActive,
                        label: {
                            Text("Chat")
                            
                        }).onChange(of: isActive, perform: { value in
                            if value {
                                self.currentRoom = "Chats"
                            }
                        })
                }
            }
            .navigationTitle("Chat now")
        }
    }
}


struct ListChatView_Previews: PreviewProvider {
    static var previews: some View {
        ListChatView()
    }
}
