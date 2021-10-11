//
//  UploadToApiApp.swift
//  UploadToApi
//
//  Created by PHONG on 02/08/2021.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import BackgroundTasks

@main
struct UploadToApiApp: App {
    
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .onOpenURL { (url) in
                    //TODO: Setup login with Facebook
                    ApplicationDelegate.shared.application(
                        UIApplication.shared,
                        open: url,
                        sourceApplication: nil,
                        annotation: [UIApplication.OpenURLOptionsKey.annotation]
                    )
                }
        }
    }
}

class Delegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        //TODO: Set up for login
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        // register for local notications
        
        application.registerForRemoteNotifications()
        
        //TODO: Register Background Tasks to Update Your App
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "pp.UploadToApi.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        //TODO: Schedule Background Tasks to Update Your App
        self.scheduleAppRefresh()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //TODO: Setup login with Facebook
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        //TODO: Setup login with Google
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if !AuthViewModel.shared.isRemember {
            AuthViewModel.shared.logout()
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
}

//TODO: Using Background Tasks to Update Your App
extension Delegate {
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "pp.UploadToApi.refresh")
        // Fetch no earlier than 15 minutes from now.
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule a new refresh task.
        scheduleAppRefresh()
        
        let operationQueue = OperationQueue()
        // Create an operation that performs the main part of the background task.
        let operation = Operation()
        
        // Provide the background task with an expiration handler that cancels the operation.
        task.expirationHandler = {
            operation.cancel()
        }
        
        // Inform the system that the background task is complete
        // when the operation completes.
        operation.completionBlock = {
            task.setTaskCompleted(success: !operation.isCancelled)
        }
        
        // Start the operation.
        operationQueue.addOperation(operation)
    }
}



