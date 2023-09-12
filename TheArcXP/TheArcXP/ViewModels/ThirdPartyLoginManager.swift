//
//  ThirdPartyLoginManager.swift
//  TheArcXP
//
//  Created by Soldier Williams on 6/2/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import ArcXP
import FBSDKLoginKit
import AuthenticationServices

typealias CommerceLogInCompletion = ((_ result: Result<UserProfile, Error>) -> Void)
public class ThirdPartyLoginManager: NSObject {
    var thirdPartyCompletion: CommerceLogInCompletion?
    var signInWithAppleViewModel: SignInWithAppleViewModel
    private var analyticsService: AnalyticsService = .shared
    
    private func showAppleLoginView() {
        let provider = ASAuthorizationAppleIDProvider()
        let requests = provider.createRequest()
        requests.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [requests])
        controller.delegate = signInWithAppleViewModel
        controller.performRequests()
    }
    
    public func signInWithApple() {
        showAppleLoginView()
    }
    
    init(thirdPartyCompletionHandler: CommerceLogInCompletion? = nil) {
        thirdPartyCompletion = thirdPartyCompletionHandler
        signInWithAppleViewModel = SignInWithAppleViewModel(completionHandler: thirdPartyCompletionHandler)
    }
    
    func logInWithFacebook() {
        LoginManager().logOut()
        
        LoginManager().logIn(permissions: [], viewController: nil) { [weak self] result in
            switch result {
            case .success:
                guard let token = AccessToken.current?.tokenString else {
                    self?.thirdPartyCompletion?(.failure(CommerceError.userAccountError(reason: .failedToParseAccessToken)))
                    return
                }
                Commerce.Identity.logInWithFacebook(token: token) { self?.thirdPartyCompletion?($0) }
                self?.analyticsService.report(event: .login(loginType: .facebook))
            case .failed(let error):
                self?.thirdPartyCompletion?(.failure(error))
            case .cancelled:
                self?.thirdPartyCompletion?(.failure(CommerceError.userAccountError(reason: .cancelledLogIn)))
            }
        }
    }
    // TODO: AM-4924 - GoogleSignIn
}
