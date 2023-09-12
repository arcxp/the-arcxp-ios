//
//  AnalyticsService.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/7/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

/// Represents an event to report to an analytics provider.
/// Can be extended in order to create custom events.
struct AnalyticsEvent {
    /// The name of the event.
    var name: String
    
    /// Additional information about the event that you wish to report.
    var params: [String: String] = [:]
}

extension AnalyticsEvent {
    ///  Creates and returns a custom `AnalyticsEvent` for a user sign up.
    ///  - Parameters:
    ///  - signUpType: represents the way the user signed up (via ArcXP, Facebook or Apple).
    ///  - Returns: An `AnalyticsEvent` representing a user sign up.
    static func userSignUp(signUpType: LoginSignUpType) -> AnalyticsEvent {
        return AnalyticsEvent(name: AnalyticsConstants.signUpEvent.rawValue,
                              params: [AnalyticsConstants.signUpType.rawValue: signUpType.rawValue])
    }
    
    ///  Creates and returns a custom `AnalyticsEvent` for a user login.
    ///  - Parameters:
    ///  - loginType: represents the way the user logged in (via ArcXP, Facebook or Apple).
    ///  - Returns: An `AnalyticsEvent` representing a user login.
    static func login(loginType: LoginSignUpType) -> AnalyticsEvent {
        return AnalyticsEvent(name: AnalyticsConstants.loginEvent.rawValue,
                              params: [AnalyticsConstants.loginType.rawValue: loginType.rawValue])
    }
}
