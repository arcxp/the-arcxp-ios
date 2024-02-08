//
//  CreateAccountView.swift
//  the-arcxp-iOS
//
//  Created by Cassandra Balbuena on 3/9/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct CreateAccountView: View {
    @State private var willShowArcXPSignUpView = false
    @State private var willShowArcXPSignInView = false
    @State private var willShowSuccessfulSignUp = false
    @State private var thirdPartyLoginManager = ThirdPartyLoginManager()
    @State var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @State var showBanner = false
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        NavigationBarTheme.navigationBarColors(background: ThemeManager.navigationBarUIKitBackgroundColor,
                                               titleColor: ThemeManager.navigationBarTextColor)
    }
    
    private func didCompleteThirdPartyLogin(_ result: Result<UserProfile, Error>) {
        switch result {
        case .success:
            willShowSuccessfulSignUp  = true
        case .failure(let error):
            showBanner = true
            bannerData = ErrorBannerModifier.BannerData(title: "Error creating your account.",
                                                        detail: error.localizedDescription, type: .error)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ThemeManager.secondaryBackgroundColor.ignoresSafeArea(.all)
                    .navigationBarTitle(Constants.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(Constants.Account.cancel) {
                                UIKitNavigation.popToRootView()
                            }
                        }
                    }
                GeometryReader { geometry in
                    VStack(alignment: .center, spacing: geometry.size.height * 0.02) {
                        Text(Constants.Account.createAccount)
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .bold()
                            .padding([.top])
                            .frame(maxHeight: geometry.size.height * 0.07)
                        
                        NavigationLink(destination: CreateArcXPAccountView().navigationBarBackButtonHidden(true),
                                       isActive: $willShowArcXPSignUpView) { EmptyView() }
                        NavigationLink(destination: CreateAccountSuccessView().navigationBarBackButtonHidden(true),
                                       isActive: $willShowSuccessfulSignUp) { EmptyView() }
                        Button(action: {
                            willShowArcXPSignUpView  = true
                        }) {
                            HStack {
                                Image(Constants.ImageName.ArcXPImage)
                                Text(Constants.CreateAccount.signUp)
                                    .fontWeight(.bold)
                                    .foregroundColor(ThemeManager.foregroundColor)
                                    .frame(maxHeight: geometry.size.height * 0.05)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: geometry.size.width * 0.85)
                            .background(Constants.Colors.Blue)
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            thirdPartyLoginManager.logInWithFacebook()
                        }) {
                            HStack {
                                Image(Constants.ImageName.FBImage)
                                Text(Constants.CreateAccount.fbSignUp)
                                    .fontWeight(.bold)
                                    .foregroundColor(ThemeManager.foregroundColor)
                                    .frame(maxHeight: geometry.size.height * 0.05)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: geometry.size.width * 0.85)
                            .background(Constants.Colors.FBBlue)
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            thirdPartyLoginManager.signInWithApple()
                        }) {
                            HStack {
                                Image(Constants.ImageName.AppleImage)
                                Text(Constants.CreateAccount.appleSignUp)
                                    .fontWeight(.bold)
                                    .foregroundColor(ThemeManager.foregroundColor)
                                    .frame(maxHeight: geometry.size.height * 0.05)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: geometry.size.width * 0.85)
                            .background(Color.black)
                            .cornerRadius(15)
                        }
                        
                        Text("By creating an account you agree to our [Terms of Service](https://www.washingtonpost.com/terms-of-service/2011/11/18/gIQAldiYiN_story.html), [Privacy Policy](https://www.washingtonpost.com/privacy-policy/2011/11/18/gIQASIiaiN_story.html) and Community Policy")
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .accentColor(.blue)
                        HStack(alignment: .center) {
                            Text(Constants.CreateAccount.existingAccount)
                                .foregroundColor(colorScheme == .dark ?
                                                 ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            NavigationLink(Constants.Login.signIn,
                                           destination: SignInView().navigationBarHidden(true),
                                           isActive: $willShowArcXPSignInView)
                            .tint(ThemeManager.buttonColor)
                        }
                    }
                }
                .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            thirdPartyLoginManager = ThirdPartyLoginManager(thirdPartyCompletionHandler: didCompleteThirdPartyLogin)
            Commerce.Identity.getConfig { result in
                switch result {
                case .success(let configOptions):
                    print(configOptions)
                case .failure(let error):
                    showBanner = true
                    bannerData = ErrorBannerModifier.BannerData(title: "Error while fetching the tenant configuration.",
                                                                detail: error.localizedDescription, type: .error)
                }
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
