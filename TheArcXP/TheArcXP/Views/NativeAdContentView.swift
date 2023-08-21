//
//  NativeAdContentView.swift
//  TheArcXP
//
//  Created by Amani Hunter on 6/12/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import ArcXP

struct NativeAdContentView: View {
    @ObservedObject private var nativeViewModel: NativeAdViewModel
    
    init (story: ArcXPContent) {
        self.nativeViewModel = NativeAdViewModel(story: story)
    }
    
    var body: some View {
        Text(Constants.GoogleAds.advertisment)
        NativeAdView(nativeViewModel: nativeViewModel)
            .frame(height: 300)
            .onAppear {
                refreshAd()
            }
    }
    
    private func refreshAd() {
        nativeViewModel.refreshAd()
    }
}

private struct NativeAdView: UIViewRepresentable {
    typealias UIViewType = GADNativeAdView
    @ObservedObject var nativeViewModel: NativeAdViewModel
    
    func makeUIView(context: Context) -> GADNativeAdView {
        if let adView = Bundle.main.loadNibNamed(Constants.GoogleAds.nativeAdView, owner: nil, options: nil)?.first as? GADNativeAdView {
            return adView
        } else {
            // Provide a default GADNativeAdView
            return GADNativeAdView()
        }
    }
    
    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        guard let nativeAd = nativeViewModel.nativeAd else { return }
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        // Associate the native ad view with the native ad object. This is required to make the ad clickable.
        nativeAdView.nativeAd = nativeAd
    }
    
    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: Constants.GoogleAds.fiveStars)
        } else if rating >= 4.5 {
            return UIImage(named: Constants.GoogleAds.fourAndHalfStars)
        } else if rating >= 4 {
            return UIImage(named: Constants.GoogleAds.fourStars)
        } else if rating >= 3.5 {
            return UIImage(named: Constants.GoogleAds.threeAndHalfStars)
        } else {
            return nil
        }
    }
}
