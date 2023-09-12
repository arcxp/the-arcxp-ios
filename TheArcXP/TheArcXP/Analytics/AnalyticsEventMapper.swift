//
//  AnalyticsEventMapper.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/7/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

/// Some analytics providers use definite formats of event names and parameters.
/// Having a protocol like this helps making a specific event mapper implementation easy to do for various analytics providers.
public protocol AnalyticsEventMapper {
    /// Maps the event name to fit the `AnalyticsEventMapper`s format.
    /// - parameter event: The name of the event to map.
    /// - returns: The mapped version of the event name.
    func name(for event: String) -> String
    
    /// Maps the parameters of the event to fit the `AnalyticsEventMapper`s format.
    /// - parameter params: The parameters from the event to map.
    /// - returns: The mapped version of the event's parameters.
    func params(for params: [String: String]) -> [String: String]
}

/// A specific implementation of the `AnalyticsEventMapper` protocol that maps to a snake case format.
public struct SnakeCaseAnalyticsEventMapper: AnalyticsEventMapper {
    public func name(for eventName: String) -> String {
        return String(describing: eventName).camelCaseToSnakeCase()
    }
    
    public func params(for params: [String: String]) -> [String: String] {
        return Dictionary(uniqueKeysWithValues: params.map {
            ($0.key.camelCaseToSnakeCase(), $0.value)
        })
    }
}

fileprivate extension String {
    /// Converts a camel case string it's corresponding snake case format.
    /// - returns: The converted string in snake case format.
    func camelCaseToSnakeCase() -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return self.camelCaseRegex(pattern: acronymPattern)?.camelCaseRegex(pattern: normalPattern)?.lowercased() ?? self.lowercased()
    }
    
    private func camelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
