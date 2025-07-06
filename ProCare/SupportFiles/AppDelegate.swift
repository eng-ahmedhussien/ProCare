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
import FirebaseCrashlytics

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
                debugPrint("❌ Error requesting notifications permission: \(error)")
            } else {
                debugPrint("✅ Notifications permission granted: \(granted)")
            }
        }
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
    
    // MARK: - FCM Token received
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("📲 Firebase FCM token: \(String(describing: fcmToken))")
        
        // Send to server
        KeychainHelper.shared.set(fcmToken ?? "", forKey: .deviceToken)
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: ["token": fcmToken ?? ""])
    }
    
    // MARK: - APNs Token mapping
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        debugPrint("📬 APNs device token received")
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
        debugPrint("📩 Notification received in foreground: \(userInfo)")
        
        // عرض الإشعار يدويًا داخل التطبيق (اختياري)
        completionHandler([.banner, .sound, .badge])
    }
    // هذه الدالة تُنفذ عندما يضغط المستخدم على الإشعار (سواء كان التطبيق في الخلفية أو مغلق وتم فتحه).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("📥 User tapped notification: \(userInfo)")
        
        completionHandler()
    }
}
