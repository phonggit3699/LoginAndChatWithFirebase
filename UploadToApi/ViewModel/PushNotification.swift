//
//  PushNotification.swift
//  UploadToApi
//
//  Created by PHONG on 11/08/2021.
//

import Foundation
import UserNotifications

class PushNotification:NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = PushNotification()
    
    func createNotification(title: String, subtitle: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.categoryIdentifier = "ACTIONS"
        
//        let date = Date().addingTimeInterval(3)
//
//        let dateComponents  = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
//        let trigger  = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: "IN-APP", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func setup(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound ,.badge]) { (_, _) in
        }
        
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

           // Print full message.
           print(userInfo)
        completionHandler([.badge, .banner, .sound])
    }
    
    //listening to action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "REPLY" {
            print("reply ...")
            
        }
        let userInfo = response.notification.request.content.userInfo

            // ...

            // With swizzling disabled you must let Messaging know about the message, for Analytics
            // Messaging.messaging().appDidReceiveMessage(userInfo)

            // Print full message.
            print(userInfo)
        completionHandler()
    }
}

