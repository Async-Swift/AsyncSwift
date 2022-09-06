//
//  AppDelegate.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import SwiftUI
import Firebase
import UserNotifications

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    // WHILE APP IS ON FOREGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey]{
            print("Message ID : ", messageID)
        }
        if let data1 = userInfo[data1Key]{
            print("data1 : ", data1)
        }
        if let data2 = userInfo[data2Key]{
            print("data2 : ", data2)
        }
        if let apsData = userInfo[aps]{
            print("apsData : ", apsData)
        }
        completionHandler([[.banner, .badge, .sound]])

        print("MESSAGE RECIEVED ON FOREGROUND")
    }

    // EXECUTE WHEN USER CLICKS NOTIFICATION WHILE APP IS ON BACKGROUND
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey]{
            print("Message ID from userNotificationCenter didRecieve : ", messageID)
        }
        completionHandler()

    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("앱이 APNS에 등록되었음")
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print("APNS가 등록에 실패 하였음")
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let deviceToken: [String:String] = ["token": fcmToken ?? ""]
        print("Device Token : ", deviceToken)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    let aps = "aps"
    let data1Key = "DATA1"
    let data2Key = "DATA2"

    static var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

    // Register for remote notifications
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions, completionHandler: {_, _ in})
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey]{
            print("Message ID : \(messageID)")
        }
        print("userInfo : ", userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}
