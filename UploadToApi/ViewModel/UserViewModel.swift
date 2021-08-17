//
//  UserViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 16/08/2021.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject{
    let db = Firestore.firestore()
    var ref: DocumentReference?
    
    func postProfile(user: UserModel) {
        
        do {
            
            try ref = db.collection("Users").addDocument(from: user)
        } catch let error {
            print("Error writing city to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getProfileByID(id: String,_ com: @escaping ([UserModel]) -> Void){
        db.collection("Users").whereField("id", isEqualTo: id).getDocuments() { (querySnapshot, err) in
            guard let data = querySnapshot else {
                return
            }
            if let err = err {
                print("Error getting documents: \(err)")
            }
            let userData = data.documents.compactMap({ (doc) -> UserModel? in
                return try? doc.data(as: UserModel.self)
            })
            DispatchQueue.main.async {
                com(userData)
            }
        }
    }
    
}
