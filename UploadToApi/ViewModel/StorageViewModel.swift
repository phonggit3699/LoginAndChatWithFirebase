//
//  StorageViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 04/08/2021.
//

import Foundation
import Firebase
import SwiftUI

class StorageViewModel: ObservableObject{
    let storage = Storage.storage()
    @AppStorage("userID") var userID = ""
    
    func uploadPhoto(image: UIImage){
        let storageRef = storage.reference()
        guard let userID = UserDefaults.standard.string(forKey: "userID") else{
            return
        }
        // Create a reference to 'images/mountains.jpg'
        let profileImagesRef = storageRef.child("images/\(userID).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            print("Image is not jpeg")
            return
        }
        profileImagesRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("success")
        }
        
    }
    
    func getImageProfile(url: URL?,_ com: @escaping (UIImage)-> Void){
        if let urlProfile = url {
            loadImage(url: urlProfile) { img in
                com(img)
            }
        }else{
            downloadProfileImage { img in
                com(img)
            }
        }
        
    }
    
    func downLoadImageURL(){
        let storageRef = storage.reference()
        let starsRef = storageRef.child("images/\(userID).jpg")

        // Fetch the download URL
        starsRef.downloadURL { url, error in
          if let error = error {
            print(error)
          } else {
            print(url!)
          }
        }
    }
    
    func loadImage (url: URL?, _ com: @escaping (UIImage)-> Void){
        
        guard let imgURL = url else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: imgURL) else{
                print("Can't get image")
                return
            }
            if  let imageFromOnline = UIImage(data: data){
                DispatchQueue.main.async {
                    com(imageFromOnline)
                }
            }
        }
    }
    
    func downloadProfileImage(_ com: @escaping (UIImage)-> Void) {
        let storageRef = storage.reference()
        guard let userUid = UserDefaults.standard.string(forKey: "userID") else{
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
