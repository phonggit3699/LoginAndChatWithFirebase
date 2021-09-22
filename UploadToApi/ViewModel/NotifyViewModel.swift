//
//  NotifyViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import Foundation
import Firebase

class NotifyViewModel: ObservableObject {
    let db = Firestore.firestore()
    var ref: DocumentReference?
    @Published var countNewNoti: Int = 0
    
    func createNotifycation(title: String, message: String, seen: Bool,type: String, time: Date) -> NotificationContent{
        return NotificationContent(title: title, message: message, seen: seen,type: type, time: time)
    }
    
    func updateNewNotification(notification: NoticationModel){
        
        do {
            try db.collection("Notificaitons").document(notification.id).setData(from: notification)
        } catch let error {
            print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getNotification(id: String,_ com: @escaping (NoticationModel) -> Void) {

        self.db.collection("Notificaitons").document(id).addSnapshotListener { document, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            
            
            if let document = document, document.exists {
                do {
                    var notificationData = try document.data(as: NoticationModel.self)
                    notificationData!.content.sort { $0.time > $1.time }
                    DispatchQueue.main.async {
                        com(notificationData!)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
    
    func countNotification(id: String) {

        self.db.collection("Notificaitons").document(id).addSnapshotListener { document, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            
            
            if let document = document, document.exists {
                do {
                    let notificationData = try document.data(as: NoticationModel.self)
                    let seenNoti = notificationData!.content.filter{$0.seen == false}
                    DispatchQueue.main.async {
                        self.countNewNoti = seenNoti.count
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
    
    func saveNotification(room: [NoticationModel]){
        guard let saveRoom = try? PropertyListEncoder().encode(room) else {
            return
        }
        UserDefaults.standard.set(saveRoom, forKey: "saveNotification")
    }
    
    func getNotificationLocal(_ com: @escaping ([NoticationModel]) -> Void){
        guard let notificationData = UserDefaults.standard.value(forKey: "saveNotification") as? Data else { return }
        
        if let notifications = try? PropertyListDecoder().decode([NoticationModel].self, from: notificationData){
            DispatchQueue.main.async {
                com(notifications)
                
            }
        }
        
    }
}
