//
//  GoogleAdsManager.swift
//  TheArcXP
//
//  Created by Amani Hunter on 5/26/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import UserMessagingPlatform
import ArcXP

class GoogleAdsManager: NSObject {
    
    let adsEnabled: Bool = true
    private let logger = Logger(label: "GoogleAdsManager")
    
    func setupGoogleAds() {
        if adsEnabled {
            GADMobileAds.sharedInstance().start()
            requestTrackingAuthorizationAndConfigureMobileAds()
        }
    }
    
    private func requestTrackingAuthorizationAndConfigureMobileAds() {
        ATTrackingManager.requestTrackingAuthorization { _ in
            self.configureUMP()
        }
    }
    
    @MainActor private func loadGDPRForm() {
        // Loads a consent form. Must be called on the main thread.
        UMPConsentForm.load(completionHandler: { [weak self] form, error in
            if let error {
                self?.logger.error("Failed to load consent form with error: \(error)")
            } else {
                /*
                 Present the form
                 
                 To ensure the display of test ads following user interaction with the GDPR form,
                 it is imperative that they opt for the default consent button instead of choosing
                 the "manage options" feature. Selecting "manage options" will prevent the appearance
                 of test ads and may result in an error when attempting to retrieve them.
                 
                 Error: Failed to receive native ad with error: Error Domain=com.google.admob Code=1
                 "Request Error: No ad to show." UserInfo={NSLocalizedDescription=Request Error:
                 No ad to show., gad_response_info=  ** Response Info **
                 */
                if UMPConsentInformation.sharedInstance.consentStatus == .required {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let rootViewController = windowScene.windows.first?.rootViewController else {
                        return
                    }
                    form?.present(from: rootViewController) { [weak self] error in
                        if let error {
                            // handle dismissal error
                            self?.logger.error("GDPR form dismissal error occured:  \(error)")
                        }
                        self?.loadGDPRForm()
                    }
                }
            }
        })
    }
    
    private func handleGDPRFormDismissal() {
        let consentStatus = UMPConsentInformation.sharedInstance.consentStatus
        switch consentStatus {
        case .obtained:
            // User provided consent
            // Proceed with your app logic here
            GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = .matureAudience
        case .notRequired:
            // Consent not required
            GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = .general
        case .required:
            // User did not provide consent or dismissed the form
            // Handle the absence of consent or any other required actions
            GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = .general
        case .unknown:
            GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = .general
        @unknown default:
            logger.error("Consent status does not match an existing case. \(consentStatus)")
        }
    }
    
    private func configureUMP() {
        let parameters = UMPRequestParameters()
        parameters.tagForUnderAgeOfConsent = false
#if DEBUG
        let debugSettings = UMPDebugSettings()
        debugSettings.geography = .EEA
        // If you are running on a physical device uncomment the line below and add your device ID
        // debugSettings.testDeviceIdentifiers = ["Device ID"]
        
        // If you are running on Xcode simulator uncomment the line below
        // debugSettings.testDeviceIdentifiers = [GADSimulatorID]
        parameters.debugSettings = debugSettings
#endif
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { [weak self] error in
                // The consent information has updated.
                if let error {
                    self?.logger.error("Failed to request consent info update with error: \(error)")
                } else {
                    // The consent information state was updated.
                    // You are now ready to see if a form is available.
                    let formStatus = UMPConsentInformation.sharedInstance.formStatus
                    if formStatus == .available {
                        self?.loadGDPRForm()
                    }
                }
            })
    }
}
