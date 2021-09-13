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
    var ref: DocumentReference?
    
    func sendMessage(chat: ChatModel, room: String) {
        
        do {
            
            try ref = db.collection(room).addDocument(from: chat)
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getMessage(room: String,_ com: @escaping ([ChatModel]) -> Void) {

        self.db.collection(room).order(by: "date").addSnapshotListener { querySnapshot, error in
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
    
   
    
}
