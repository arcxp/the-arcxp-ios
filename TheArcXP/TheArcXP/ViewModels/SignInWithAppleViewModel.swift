//
//  SignInWithAppleViewModel.swift
//  TheArcXP
//
//  Created by Soldier Williams on 6/2/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import AuthenticationServices
import ArcXP
import SwiftUI

class SignInWithAppleViewModel: NSObject, ASAuthorizationControllerDelegate {
    var handler: CommerceLogInCompletion?
    @State var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @State var showBanner = false
    private var analyticsService: AnalyticsService = .shared
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCodeData = credential.authorizationCode,
              let token = String(data: authorizationCodeData, encoding: .utf8) else {
                  handler?(.failure(CommerceError.userAccountError(reason: .failedThirdPartyAuthentication)))
            return
        }
        
        Commerce.Identity.logInWithApple(token: token, completion: handler)
        analyticsService.report(event: .login(loginType: .apple))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        showBanner = true
        bannerData = ErrorBannerModifier.BannerData(
            title: ErrorType.fetchCollectionFail.rawValue,
            detail: error.localizedDescription,
            type: .error)
    }
    
    init(completionHandler: CommerceLogInCompletion? = nil) {
        handler = completionHandler
    }
}
