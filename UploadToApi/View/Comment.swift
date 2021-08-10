//
//  Comment.swift
//  UploadToApi
//
//  Created by PHONG on 07/08/2021.
//

import SwiftUI

struct Comment: View {
    @ObservedObject var rtDb = RealtimeDatabase()
    @EnvironmentObject var auth: AuthViewModel
    
    init(){
        rtDb.readDataTest()
    }
    
    var body: some View {
        VStack{
            Button(action: {
                rtDb.writeDataTest(username: auth.auth.currentUser?.displayName ?? "", userUid: auth.auth.currentUser?.uid ?? "")
            }, label: {
                Label(
                    title: { Text("Send") },
                    icon: { Image(systemName: "paperplane.fill") }
)
            })
            
            List(){
                ForEach(rtDb.userData){data in
                    Text(data.id)
                    Text(data.username)
                }
            }
        }
    }
}

struct Comment_Previews: PreviewProvider {
    static var previews: some View {
        Comment().environmentObject(AuthViewModel())
    }
}
