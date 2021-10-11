//
//  ChatViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 08/08/2021.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject{
    let db = Firestore.firestore()
    var docRef: DocumentReference?
    
    func sendMessage(chat: ChatModel, roomId: String) {
        
        do {
            
            self.docRef = try self.db.collection("Chats").document(roomId).collection("StoreChat").addDocument(from: chat)
        } catch{
            print("Error send message: \(error.localizedDescription)")
        }
    }
    
    func getMessage(roomId: String,_ com: @escaping ([ChatModel]) -> Void) {
        
        self.db.collection("Chats").document(roomId).collection("StoreChat").order(by: "date").addSnapshotListener {querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let chatData = data.documents.compactMap({ (doc) -> ChatModel? in
                return try? doc.data(as: ChatModel.self)
            })
            
            DispatchQueue.main.async {
                com(chatData)
            }
            
        }
        
        
    }
    
    func getLastMessage(roomId: String,_ com: @escaping ([ChatModel]) -> Void){
        self.db.collection("Chats").document(roomId).collection("StoreChat").order(by: "date", descending: true).limit(to: 1).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            
            let chatData = data.documents.compactMap({ (doc) -> ChatModel? in
                return try? doc.data(as: ChatModel.self)
            })
            
            DispatchQueue.main.async {
                com(chatData)
            }
            
        }
        
    }
    
    
    
}
