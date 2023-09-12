//
//  AppDelegate.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/15/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import SwiftUI
import ArcXP
import FBSDKCoreKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var googleAdsManager = GoogleAdsManager()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        SDKInitializer.initializeArcXPSDKs()
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        FirebaseApp.configure()
        let snakeCaseEventMapper = SnakeCaseAnalyticsEventMapper()
        // Comment the line of code below to disable Google Analytics event reporting.
        AnalyticsService.register(provider: GoogleAnalyticsProvider(eventMapper: snakeCaseEventMapper))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        return true
    }
    
    @objc func appDidBecomeActive() {
        googleAdsManager.setupGoogleAds()
    }
}
