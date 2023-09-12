//
//  AnalyticsService.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/7/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

/// A protocol that any analytics provider (Google Analytics in this case) will need to implement/conform to.
public protocol AnalyticsProvider {
    /// Reports an event to the provider.
    /// - Parameters:
    ///     - name: Name of the event to report.
    ///     - params: Additional information to log with the event.
    func reportEvent(name: String, params: [String: String])
    
    /// Reports a screen view to the provider.
    /// - Parameters:
    ///     - viewName: Name of the screen that has been viewed.
    ///     - className: Name of the screen's class.
    ///     - extraParams: Additional information to log with the screen view.
    func reportScreen(viewName: String, className: String?, extraParams: [String: String]?)
}

/// This class interacts with view controllers to report any events to registered `AnalyticsProvider`s.
public final class AnalyticsService {
    /// List of `AnalyticsProvider`s registered to the service.
    private static var providers = [AnalyticsProvider]()
    static let shared = AnalyticsService(providers: providers)
    
    private init(providers: [AnalyticsProvider]) {
        AnalyticsService.providers = providers
    }
    
    /// Registers an `AnalyticsProvider` to this service.
    static func register(provider: AnalyticsProvider) {
        providers.append(provider)
    }
    
    /// Reports an event to all registered `AnalyticsProvider`s.
    /// - parameter event: The `AnalyticsEvent` to report.
    func report(event: AnalyticsEvent) {
        AnalyticsService.providers.forEach {
            $0.reportEvent(name: event.name, params: event.params)
        }
    }
    
    /// Reports a screen view to all registered `AnalyticsProvider`s.
    /// - parameter screen: The `AnalyticsScreen` to report a screen view for.
    func reportScreenView(screen: AnalyticsScreen) {
        AnalyticsService.providers.forEach {
            $0.reportScreen(viewName: screen.name, className: screen.className, extraParams: screen.params)
        }
    }
}
