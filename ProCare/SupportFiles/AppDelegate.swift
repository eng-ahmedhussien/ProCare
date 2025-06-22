//
//  AppDelegate.swift
//  ProCare
//
//  Created by ahmed hussien on 22/06/2025.
//


import SwiftUI
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications


// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Firebase setup
        FirebaseApp.configure()
        
        // تعيين ال delegates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        // طلب إذن الإشعارات
        requestNotificationAuthorization(application: application)
        
        return true
    }
    
    private func requestNotificationAuthorization(application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print("❌ Error requesting notifications permission: \(error)")
            } else {
                print("✅ Notifications permission granted: \(granted)")
            }
        }
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
    
    // MARK: - FCM Token received
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("📲 Firebase FCM token: \(String(describing: fcmToken))")
        
        // Send to server if needed
        KeychainHelper.shared.set(fcmToken ?? "", forKey: .deviceToken)
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken ?? ""])
    }
    
    // MARK: - APNs Token mapping
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("📬 APNs device token received")
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // استقبل الإشعار داخل التطبيق
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("📩 Notification received in foreground: \(userInfo)")
        
        // عرض الإشعار يدويًا داخل التطبيق (اختياري)
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("📥 User tapped notification: \(userInfo)")
        
        completionHandler()
    }
}


//class AppDelegate: NSObject, UIApplicationDelegate {
////    func application(_ application: UIApplication,
////                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
////        FirebaseApp.configure()
////        
////        Messaging.messaging().delegate = self
////        
////        // Register for remote notifications. This shows a permission dialog on first run, to
////        // show the dialog at a more appropriate time move this registration accordingly.
////        // [START register_for_notifications]
////        UNUserNotificationCenter.current().delegate = self
////        
////        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
////        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
////        
////        application.registerForRemoteNotifications()
////        
////        Messaging.messaging().token { token, error in
////            if let error {
////                print("Error fetching FCM registration token: \(error)")
////            } else if let token {
////                print("FCM registration token: \(token)")
////            }
////        }
////        return true
////    }
//    
//    func application(_ application: UIApplication,
//                       didFinishLaunchingWithOptions launchOptions: [UIApplication
//                         .LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//
//        // [START set_messaging_delegate]
//        Messaging.messaging().delegate = self
//        // [END set_messaging_delegate]
//
//        // Register for remote notifications. This shows a permission dialog on first run, to
//        // show the dialog at a more appropriate time move this registration accordingly.
//        // [START register_for_notifications]
//
//        UNUserNotificationCenter.current().delegate = self
//
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: { _, _ in })
//
//        // لتسجيل التطبيق لتلقي الإشعارات.
//        application.registerForRemoteNotifications()
//
//        // [END register_for_notifications]
//
//        return true
//      }
//    
//    
//    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Oh no! Failed to register for remote notifications with error \(error)")
//    }
//
//    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var readableToken = ""
//        for index in 0 ..< deviceToken.count {
//            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
//        }
//        print("Received an APNs device token: \(readableToken)")
//    }
//}
//
//
//
//extension AppDelegate: MessagingDelegate {
//    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase token: \(String(describing: fcmToken))")
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(
//        _: UNUserNotificationCenter,
//        willPresent _: UNNotification,
//        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//    ) {
//        completionHandler([[.banner, .list, .sound]])
//    }
//
//    func userNotificationCenter(
//        _: UNUserNotificationCenter,
//        didReceive response: UNNotificationResponse,
//        withCompletionHandler completionHandler: @escaping () -> Void
//    ) {
//        let userInfo = response.notification.request.content.userInfo
//        NotificationCenter.default.post(
//            name: Notification.Name("didReceiveRemoteNotification"),
//            object: nil,
//            userInfo: userInfo
//        )
//        completionHandler()
//    }
//}
//
