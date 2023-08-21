//
//  PaywallLoader.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 8/25/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import ArcXP

struct PaywallLoader {
    
    /// Determines whether a paywall should be shown for the given article id, and paywall evaluation.
    /// - returns: A boolean indicating whether the paywall should be shown or not.
    static func shouldShowPaywall(contentID: String, contentType: PaywallConstants.ContentType) -> Bool {
        // Logged in users don't have to be budgeted. So, no paywall evaluation here
        // In future when subscription takes place, it will be handled in a different way.
        guard Commerce.cachedUserProfile == nil  else { return false }

        let conditions = ["deviceClass": PaywallConstants.DeviceClass.mobile.rawValue,
                          "contentType": contentType.rawValue]

        // Report whether paywall should be shown, based on whether content should be shown or not.
        // If the result is failure, it means, the paywall rules are tripped and so, the paywall screen should be shown
        // If the result is success, the conditions are still getting satisifed and so the paywall screen will not be shown
        let result = PaywallManager.evaluate(contentID: contentID,
                                             conditions: conditions,
                                             countTowardsBudget: true)
        switch result {
        case .failure(let paywallError):
            if case .rulesTripped = paywallError {
                LoggingManager.log("Paywall rules tripped", level: .warning)
            } else {
                LoggingManager.log("Paywall evaluation failed with error: \(paywallError.localizedDescription)", level: .error)
            }
            return true
        case .success:
            LoggingManager.log("Rule is satisfied", level: .info)
            return false
        }
    }
    
}
