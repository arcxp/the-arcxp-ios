//
//  NativeAdViewModel.swift
//  TheArcXP
//
//  Created by Amani Hunter on 6/12/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import ArcXP

class NativeAdViewModel: NSObject, ObservableObject, GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    
    @Published var nativeAd: GADNativeAd?
    private var adLoader: GADAdLoader!
    private var metaData = ContentMetadata(keywords: [], articleURL: "")
    private let logger = Logger(label: "NativeAdViewModel")
    
    init(story: ArcXPContent) {
        metaData.updateArticleMetadata(content: story)
    }
    
    func refreshAd() {
        adLoader = GADAdLoader(
            adUnitID:
                Constants.GoogleAds.nativeAdUnitID ?? "",
            rootViewController: nil,
            adTypes: [.native], options: nil)
        adLoader.delegate = self
        let adRequest = GADRequest()
        // supply the request with metadata
        adRequest.keywords = metaData.keywords
        adRequest.contentURL = metaData.articleURL
        adLoader.load(GADRequest())
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        self.nativeAd = nativeAd
        nativeAd.delegate = self
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        logger.error("Failed to receive native ad with error: \(error)")
    }
}
