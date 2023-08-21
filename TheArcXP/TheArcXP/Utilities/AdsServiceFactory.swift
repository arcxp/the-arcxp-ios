//
//  AdsServiceFactory.swift
//  TheArcXP
//
//  Created by Amani Hunter on 5/22/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

protocol AdsService {
    func adsEnabled() -> Bool
}

struct SignedInAdsService: AdsService {
    func adsEnabled() -> Bool {
        false
    }
}

struct SignedOutAdsService: AdsService {
    func adsEnabled() -> Bool {
        true
    }
}

class AdsServiceFactory {
    static let shared = AdsServiceFactory()
    
    private init() {}
    
    func createAdsService(completion: @escaping (AdsService) -> Void) {
        Commerce.isLoggedIn { isLoggedIn in
            let adsService: AdsService
            switch isLoggedIn {
            case true:
                adsService = SignedInAdsService()
            case false:
                adsService = SignedOutAdsService()
            }
            completion(adsService)
        }
    }
}
