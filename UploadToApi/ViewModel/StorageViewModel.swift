//
//  StorageViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 04/08/2021.
//

import Foundation
import Firebase

class StorageViewModel: ObservableObject{
    let storage = Storage.storage()
    
    
    func uploadPhoto(image: UIImage){
        let storageRef = storage.reference()
        guard let userUid = UserDefaults.standard.string(forKey: "UserUid") else{
            return
        }
        // Create a reference to 'images/mountains.jpg'
        let profileImagesRef = storageRef.child("images/\(userUid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        profileImagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
//            profileImagesRef.downloadURL { (url, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let downloadURL = url else {
//                    return
//                }
//                UserDefaults.standard.set(downloadURL, forKey: "profileImageUrl")
//            }
        }
        
    }
    
    
    func downloadProfileImage(_ com: @escaping (UIImage)-> Void) {
        let storageRef = storage.reference()
        guard let userUid = UserDefaults.standard.string(forKey: "UserUid") else{
            return
        }
        // Create a reference to the file you want to download
        let islandRef = storageRef.child("images/\(userUid).jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
          if let error = error {
            print(error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            guard let image = UIImage(data: data!) else{
                return
            }
            DispatchQueue.main.async {
                com(image)
            } 
          }
        }
        
    }
}
