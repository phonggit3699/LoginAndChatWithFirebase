//
//  NotifyViewModel.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import SwiftUI
import Firebase

class NotifyViewModel: NSObject, ObservableObject {
    let db = Firestore.firestore()
    var ref: DocumentReference?
    @Published var countNewNotification: Int = 0
    @Published var countNewChat: Int = 2
    @Published var countNewFeed: Int = 6
    
    
    func addNotification(id: String, newNotification: NotificationModel){
        
        do {
            //Update
            try self.db.collection("Notifications").document(id).collection("StoreNotification").document(newNotification.id).setData(from: newNotification)
            
        } catch {
            print("Error writing Notificaitons to Firestore: \(error.localizedDescription)")
        }
        
    }
    
    
    func loadNotificationImage(url: URL?, _ com: @escaping (UIImage)-> Void){
        guard let imgURL = url else {
            print("Url error")
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imgURL) else{
                print("Can't get image")
                return
            }
            if  let imageFromURL = UIImage(data: data){
                DispatchQueue.main.async {
                    com(imageFromURL)
                }
            }
        }
    }
    
    
    func updateSeenNotification(id: String, idNotifi:String, message: String, isPress: Bool){
        self.db.collection("Notifications").document(id).collection("StoreNotification")
            .document(idNotifi).updateData(["seen" : true, "isPress" : isPress, "message" : message])
    }
    
    func getNotification(id: String,_ com: @escaping ([NotificationModel]) -> Void) {
        
        self.db.collection("Notifications").document(id).collection("StoreNotification").addSnapshotListener {querySnapshot, error in
            
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let notificationData = data.documents.compactMap({ (doc) -> NotificationModel? in
                return try? doc.data(as: NotificationModel.self)
            })
            
            DispatchQueue.main.async {
                com(notificationData)
            }
        }
        
    }
    
    func countNotification(id: String) {
        
        self.db.collection("Notifications").document(id).collection("StoreNotification").addSnapshotListener {querySnapshot, error in
            
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let notificationData = data.documents.compactMap({ (doc) -> NotificationModel? in
                return try? doc.data(as: NotificationModel.self)
            })
            
            let seenNoti = notificationData.filter{$0.seen == false}
            
            DispatchQueue.main.async {
                self.countNewNotification = seenNoti.count
            }
        }
        
    }
    
    func countNewMessage(roomId: String) {
        
        self.db.collection("Chats").document(roomId).collection("StoreNotification").addSnapshotListener {querySnapshot, error in
            
            if let error = error {
                print("Error retreiving collection: \(error.localizedDescription)")
                return
            }
            
            guard let data = querySnapshot else {
                return
            }
            
            let notificationData = data.documents.compactMap({ (doc) -> NotificationModel? in
                return try? doc.data(as: NotificationModel.self)
            })
            
            let seenNoti = notificationData.filter{$0.seen == false}
            
            DispatchQueue.main.async {
                self.countNewNotification = seenNoti.count
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
    case addfriend
}

extension NotifyViewModel: UNUserNotificationCenterDelegate {
    
    func setUpPushNotificationLocal(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound ,.badge]) { (_, _) in
        }
        
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    }
    
    func createNotificationLocal(title: String, subTitle: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.categoryIdentifier = "ACTIONS"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        
        let request = UNNotificationRequest.init(identifier: "IN-APP", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .sound])
    }
    
    // listening to action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "REPLY" {
            print("reply ...")
            
        }
        completionHandler()
    }
}
