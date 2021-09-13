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
    
    func addRoomChat(id: String, room: RoomModel){
        
        do {
            try db.collection("Rooms").document(id).setData(from: room)
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
}
