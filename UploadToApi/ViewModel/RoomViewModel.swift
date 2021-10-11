//
//  RoomViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 13/09/2021.
//

import SwiftUI
import Firebase

class RoomViewModel: ObservableObject{
   
    @Published var isPending: Bool = false
    @Published var isFriend: Bool = false
    
    @AppStorage("userID") var userID = ""
    
    let db = Firestore.firestore()
    var ref: DocumentReference?
    
    
    
    func addRoomChat(id: String, newRoom: RoomModel){
       
        do {
            //Update
            try self.db.collection("Rooms").document(id).collection("StoreRoom").document(newRoom.id).setData(from: newRoom)
            
        } catch {
            print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getRoomChat(id: String,_ com: @escaping ([RoomModel]) -> Void){
        self.db.collection("Rooms").document(id).collection("StoreRoom").addSnapshotListener {querySnapshot, error in
            
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let roomData = data.documents.compactMap({ (doc) -> RoomModel? in
                return try? doc.data(as: RoomModel.self)
            })
            
            DispatchQueue.main.async {
                com(roomData)
            }
        }
        
    }

    
    func friendCheck(otherId: String){
        self.db.collection("Rooms").document(userID).collection("StoreRoom").whereField("friendId", isEqualTo: otherId).getDocuments { querySnapshot, error in
            
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let roomData = data.documents.compactMap({ (doc) -> RoomModel? in
                return try? doc.data(as: RoomModel.self)
            })
            
            DispatchQueue.main.async {
                if roomData.count > 0 {
                    self.isFriend = true
                }else{
                    self.isFriend = false
                }
            }
        }
    }
    
    func saveRoom(room: [RoomModel]){
        guard let saveRoom = try? PropertyListEncoder().encode(room) else {
            return
        }
        UserDefaults.standard.set(saveRoom, forKey: "saveRooms")
    }
    
    func getRoomLocal(_ com: @escaping ([RoomModel]) -> Void){
        guard let roomData = UserDefaults.standard.value(forKey: "saveRooms") as? Data else { return }
        
        if let room = try? PropertyListDecoder().decode([RoomModel].self, from: roomData){
            DispatchQueue.main.async {
                com(room)
                
            }
        }
        
    }
}
