//
//  GoogleAnalyticsProvider.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/7/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation
import FirebaseAnalytics

/// A specific implementation of the `AnalyticsProvider`protocol using Google Analytics as the provider.
public struct GoogleAnalyticsProvider: AnalyticsProvider {
    /// Maps events to fit the format that Google Analytics reports events.
    private let eventMapper: AnalyticsEventMapper

    public func reportEvent(name: String, params: [String: String]) {
        let mappedName = eventMapper.name(for: name)
        let mappedParameters = eventMapper.params(for: params)
        Analytics.logEvent(mappedName, parameters: mappedParameters)
    }
    
    public func reportScreen(viewName: String, className: String? = nil, extraParams: [String: String]? = nil) {
        let mappedViewName = eventMapper.name(for: viewName)
        var params: [String: String] = [AnalyticsParameterScreenName: mappedViewName]
        var mappedClassName = ""
        var mappedParameters = [String: String]()
        
        if let screenClass = className {
            mappedClassName = eventMapper.name(for: screenClass)
            params[AnalyticsParameterScreenClass] = mappedClassName
        }
        
        if let extraParams = extraParams {
            mappedParameters = eventMapper.params(for: extraParams)
            params.merge(mappedParameters) { _, new in new }
        }
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: params)
    }
        
    init(eventMapper: AnalyticsEventMapper) {
        self.eventMapper = eventMapper
    }
}
