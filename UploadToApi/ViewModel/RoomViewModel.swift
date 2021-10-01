//
//  RoomViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 13/09/2021.
//

import Foundation
import Firebase

class RoomViewModel: ObservableObject{
    let db = Firestore.firestore()
    var ref: DocumentReference?
    
    func createRoomChat(id: String){
        let firstRoom = RoomModel(id: "", listRoom: [])
        do {
            try db.collection("Rooms").document(id).setData(from: firstRoom)
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func addRoomChat(id: String, newRoom: RoomDetailModel){
        var currentRoom: [RoomDetailModel] = []
        
        self.getRoomChat(id: id) { room in
            currentRoom = room.listRoom
        }
        
        currentRoom.append(newRoom)
        
        do {
            try db.collection("Rooms").document(id).setData(from: RoomModel(id: id, listRoom: currentRoom))
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getRoomChat(id: String,_ com: @escaping (RoomModel) -> Void){
        let docRef = db.collection("Rooms").document(id)
        docRef.getDocument{[weak self]  (document, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            if let document = document, document.exists {
                do {
                    let roomData = try document.data(as: RoomModel.self)
                    DispatchQueue.main.async {
                        com(roomData!)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                self?.createRoomChat(id: id)
                
                print("Document does not exist")
            }
            
        }
    }
    
    func saveRoom(room: RoomModel){
        guard let saveRoom = try? PropertyListEncoder().encode(room) else {
            return
        }
        UserDefaults.standard.set(saveRoom, forKey: "saveRooms")
    }
    
    func getRoomLocal(_ com: @escaping (RoomModel) -> Void){
        guard let roomData = UserDefaults.standard.value(forKey: "saveRooms") as? Data else { return }
        
        if let room = try? PropertyListDecoder().decode(RoomModel.self, from: roomData){
            DispatchQueue.main.async {
                com(room)
                
            }
        }
        
    }
}
