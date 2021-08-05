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
        
        // Create a reference to 'images/mountains.jpg'
        let profileImagesRef = storageRef.child("images/profile.jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        profileImagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            profileImagesRef.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let downloadURL = url else {
                    return
                }
                UserDefaults.standard.set(downloadURL, forKey: "profileImageUrl")
            }
        }
        
    }
    
    func downloadProfileImage(_ com: @escaping (UIImage)-> Void) {
        guard let profileImageUrl = UserDefaults.standard.url(forKey: "profileImageUrl") else{
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: profileImageUrl){
                if  let imageProfile = UIImage(data: data){
                    DispatchQueue.main.async {
                      com(imageProfile)
                    }
                }
            }
        }
        
    }
}
