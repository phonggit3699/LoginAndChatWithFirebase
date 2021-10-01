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
    @Published var countNewNotification: Int = 0
    @Published var countNewChat: Int = 27
    @Published var countNewFeed: Int = 6
    
    
    func createNotifycation(title: String, message: String, seen: Bool,type: String, time: Date, idSend: String) -> NotificationContent{
        return NotificationContent(title: title, message: message, seen: seen,type: type, time: time, idSend: idSend)
    }
    
    func updateNewNotification(id: String, newNotification: NotificationContent){
        var notificationContent: [NotificationContent] = []
        
        //get previous notification
        getNotification(id: id) { notiData in
            notificationContent = notiData.content
        }
        // append new notification
        notificationContent.append(newNotification)

        do {
            //Update
            try db.collection("Notifications").document(id).setData(from: NotificationModel(id: id, content: notificationContent))
            
        } catch let error {
            print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
        }
        
    }
    
    func updateSeenNotification(id: String, notification: NotificationModel){
        do {
            //Update
            try db.collection("Notifications").document(id).setData(from: notification)
        } catch let error {
            print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
        }
    }
    
    func getNotification(id: String,_ com: @escaping (NotificationModel) -> Void) {
        
        self.db.collection("Notifications").document(id).addSnapshotListener {[weak self] document, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            
            
            if let document = document, document.exists {
                do {
                    var notificationData = try document.data(as: NotificationModel.self)
                    notificationData!.content.sort { $0.time < $1.time }
                    DispatchQueue.main.async {
                        com(notificationData!)
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                do {
                    // create new collection Notification on Firebase
                    try self?.db.collection("Notifications").document(id).setData(from: NotificationModel(id: id, content: []))
                } catch let error {
                    print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
                }
                print("create new collection Notification")
            }
            
        }
        
    }
    
    func countNotification(id: String) {
        
        self.db.collection("Notifications").document(id).addSnapshotListener { document, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            }
            
            
            if let document = document, document.exists {
                do {
                    let notificationData = try document.data(as: NotificationModel.self)
                    let seenNoti = notificationData!.content.filter{$0.seen == false}
                    DispatchQueue.main.async {
                        self.countNewNotification = seenNoti.count
                    }
                }catch{
                    print(error.localizedDescription)
                }
                
                
            } else {
                print("Document does not exist")
            }
            
        }
        
    }
    
    func saveNotification(room: [NotificationModel]){
        guard let saveRoom = try? PropertyListEncoder().encode(room) else {
            return
        }
        UserDefaults.standard.set(saveRoom, forKey: "saveNotification")
    }
    
    func getNotificationLocal(_ com: @escaping ([NotificationModel]) -> Void){
        guard let notificationData = UserDefaults.standard.value(forKey: "saveNotification") as? Data else { return }
        
        if let notifications = try? PropertyListDecoder().decode([NotificationModel].self, from: notificationData){
            DispatchQueue.main.async {
                com(notifications)
                
            }
        }
        
    }
}

enum NotificationType: String{
    case normal
    case addafriend
}
