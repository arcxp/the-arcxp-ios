//
//  AppDelegate.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/15/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications
import ArcXP
import FBSDKCoreKit
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private var googleAdsManager = GoogleAdsManager()
    private let remoteNotificationsLogger = Logger(label: "PushNotifications")
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        SDKInitializer.initializeArcXPSDKs()
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        registerForRemoteNotifications()
        let snakeCaseEventMapper = SnakeCaseAnalyticsEventMapper()
        
        if Bundle.main.path(forResource: Constants.AppInfo.googlePlist, ofType: Constants.AppInfo.plist) != nil {
            FirebaseApp.configure()
            AnalyticsService.register(provider: GoogleAnalyticsProvider(eventMapper: snakeCaseEventMapper))
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        return true
    }
    
    @objc func appDidBecomeActive() {
        googleAdsManager.setupGoogleAds()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    private func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (permissionGranted, error) in
            // Check if permission is granted
            guard permissionGranted, error == nil else {
                if let error {
                    self.remoteNotificationsLogger.error("Error requesting authorization for push notifications: \(error)")
                }
                return
            }
            // Attempt registration for notifications on the main thread
            DispatchQueue.main.async {
                self.getNotificationSettings()
            }
        }
    }
    
   private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        remoteNotificationsLogger.error("Failed to register for remote notifications with error: \(error)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        NotificationCenter.default.post(Notification(name: Notification.Name(Constants.RemoteNotifications.didReceiveNotification)))
        Messaging.messaging().appDidReceiveMessage(userInfo)
        return .newData
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled we must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // preferred presentation option
        return [[.banner, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        // Proccess touch of notification
        process(response.notification)
    }
    
    func process(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let uuid = userInfo[Constants.RemoteNotifications.uuid] as? String,
              let contentType = userInfo[Constants.RemoteNotifications.contentType] as? String else { return }
        remoteNotificationsLogger.info("Processed Notification. UUID:\(uuid), content-type: \(contentType) ")
        PushNotificationNavigationManager.shared.navigateToDetail = true
        PushNotificationNavigationManager.shared.uuid = uuid
        PushNotificationNavigationManager.shared.contentType = contentType
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = [Constants.RemoteNotifications.token: fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name(Constants.RemoteNotifications.fcmNotification),
                                        object: nil,
                                        userInfo: dataDict)
        // if necessary send token to server
        // function is called each startup and when a new token is generated.
    }
}
