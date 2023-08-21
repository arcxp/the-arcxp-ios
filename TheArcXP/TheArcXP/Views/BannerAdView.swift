//
//  BannerView.swift
//  TheArcXP
//
//  Created by Amani Hunter on 5/15/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdContentView: View {
    let metaData: ContentMetadata
    let height: CGFloat
    @State var size: CGSize = .zero
    var body: some View {
        VStack {
            Text(Constants.GoogleAds.advertisment)
            BannerAdView(articleMetadata: metaData)
        }
        .frame(height: height)
    }
}

struct BannerAdView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    private var metaData: ContentMetadata
    private var adUnitID = Constants.GoogleAds.bannerAdUnitID
    
    init(articleMetadata: ContentMetadata) {
        self.metaData = articleMetadata
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerAdViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.delegate = context.coordinator
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else {return}
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        let adRequest = GADRequest()
        // Sets the keywords associated with the ad request
        adRequest.keywords = metaData.keywords
        // Providing a content URL can help the ad network understand the context and serve more relevant ads.
        adRequest.contentURL = metaData.articleURL
        bannerView.load(adRequest)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, BannerAdViewControllerWidthDelegate, GADBannerViewDelegate {
        let parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        
        func bannerAdViewController(_ bannerViewController: BannerAdViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
        // MARK: - GADBannerViewDelegate methods
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        }
    }
}
