//
//  RealtimeDatabase.swift
//  UploadToApi
//
//  Created by PHONG on 07/08/2021.
//

import Foundation
import FirebaseDatabase

class RealtimeDatabase: ObservableObject {
    @Published var userData: [RealTimeModel] = []
    var ref: DatabaseReference! = Database.database(url: "https://uploadfile-43e92-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    var refHandle: DatabaseHandle?
    func writeDataTest(username: String, userUid: String){
        self.ref.child("users").child(userUid)
            .setValue([ "userID": userUid,
                        "username": username
            ])
    }
    
    func readDataTest(){
        let postRef = self.ref.child("users")
        
        refHandle = postRef.observe(.childAdded, with: { snapshot in
            
            guard let value = snapshot.value as? NSDictionary else {
                return
            }
            
            let username = value["username"] as? String ?? ""
            let userID = value["userID"] as? String ?? ""
            self.userData.append(RealTimeModel(id: userID, username: username))
        })
    }
}

struct RealTimeModel: Identifiable, Codable {
    var id: String
    var username: String
}
