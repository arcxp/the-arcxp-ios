//
//  SignInView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 4/20/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var checked = false
    @State var navigatedForgotPassword = false
    @State var navigatedCreateAccount = false
    @State var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @State var showBanner = false
    @State var shouldLoadSpinner = false
    @StateObject private var userViewModel = UserViewModel()
    private var loginModel = UserProfile()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSignInView: Bool
    @State private var thirdPartyLoginManager: ThirdPartyLoginManager!
    private var analyticsService: AnalyticsService = .shared
    
    var textFieldsValid: Bool {
        return (!email.isEmpty && !password.isEmpty)
    }
    
    var buttonColor: Color {
        return textFieldsValid ? ThemeManager.authButtonColor : ThemeManager.authTextFieldsNotValidColor
    }
    
    init(showSignInView: Binding<Bool> = .constant(false)) {
        _showSignInView = showSignInView
    }
    
    private func didCompleteThirdPartyLogin(_ result: Result<UserProfile, Error>) {
        switch result {
        case .success:
            showSignInView = false
        case .failure(let error):
            showSignInView = true
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
                    .navigationBarItems(
                        leading:
                            Button(Constants.Account.cancel) {
                                UIKitNavigation.popToRootView()
                            }
                    )
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            HStack {
                                Text(Constants.Login.signIn)
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .padding([.leading, .top])
                                    .foregroundColor(colorScheme == .dark ?
                                                     ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                                Spacer()
                            }
                            
                            TextField(Constants.Login.email, text: $email)
                                .padding()
                                .cornerRadius(15.0)
                                .padding(.bottom, 20)
                                .frame(maxWidth: geometry.size.width * 0.9)
                            
                            SecureInput(placeholder: Constants.Login.password, text: $password)
                                .padding()
                                .cornerRadius(15.0)
                                .padding(.bottom, 20)
                                .frame(maxWidth: geometry.size.width * 0.9)
                            
                            Button(action: {
                                Commerce.Identity.logIn(username: email,
                                                        password: password,
                                                        rememberMe: checked) { result in
                                    switch result {
                                    case .success:
                                        analyticsService.report(event: .login(loginType: .arcxp))
                                        UIKitNavigation.popToRootView()
                                    case .failure(let error):
                                        showBanner = true
                                        bannerData = ErrorBannerModifier.BannerData(title: Constants.Login.errorLogin,
                                                                                    detail: error.localizedDescription,
                                                                                    type: .error)
                                    }
                                }
                            }) {
                                LoginButtonContent()
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .background(buttonColor)
                                    .cornerRadius(15)
                            }
                            .disabled(email.isEmpty || password.isEmpty)
                            
                            HStack {
                                Image(systemName: checked ? Constants.ImageName.boxedcheckmark : Constants.ImageName.square)
                                    .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
                                    .onTapGesture {
                                        checked.toggle()
                                    }
                                Text(Constants.Login.rememberMe)
                                    .padding(.vertical, 20)
                                    .foregroundColor(colorScheme == .dark ?
                                                     ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                                Spacer()
                            }
                            .frame(maxWidth: geometry.size.width * 0.9)
                            
                            HStack(alignment: .center) {
                                Text(Constants.Login.noAccount)
                                    .foregroundColor(colorScheme == .dark ?
                                                     ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                                NavigationLink(Constants.Login.register,
                                               destination: CreateAccountView().navigationBarHidden(true),
                                               isActive: $navigatedCreateAccount)
                                .accentColor(ThemeManager.buttonColor)
                            }
                            .padding(.bottom, 20)
                            
                            Group {
                                NavigationLink(Constants.Login.forgotPassword,
                                               destination: ForgotPasswordView(userViewModel: userViewModel).navigationBarHidden(true),
                                               isActive: $navigatedForgotPassword)
                                .accentColor(ThemeManager.buttonColor)
                            }
                            Button(action: {
                                thirdPartyLoginManager.logInWithFacebook()
                            }) {
                                LoginFBButtonContent()
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .background(Constants.Colors.FBBlue)
                                    .cornerRadius(15)
                            }
                            Button(action: {
                                thirdPartyLoginManager.signInWithApple()
                            }) {
                                LoginAppleButtonContent()
                                    .padding()
                                    .frame(maxWidth: geometry.size.width * 0.9)
                                    .background(Color.black)
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .background(colorScheme == .dark ?
                                ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                }
            }
        }
        .autocapitalization(.none)
        .banner(data: $bannerData, show: $showBanner)
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

struct LoginButtonContent: View {
    var body: some View {
        HStack {
            Spacer()
            Text(Constants.Login.signIn)
                .fontWeight(.bold)
                .foregroundColor(ThemeManager.foregroundColor)
            Spacer()
        }
    }
}

struct LoginFBButtonContent: View {
    var body: some View {
        HStack {
            Image(Constants.ImageName.FBImage)
            Text(Constants.Login.fbSignIn)
                .fontWeight(.bold)
                .foregroundColor(ThemeManager.foregroundColor)
            Spacer()
        }
    }
}

struct LoginAppleButtonContent: View {
    var body: some View {
        HStack {
            Image(Constants.ImageName.AppleImage)
            Text(Constants.Login.appleSignIn)
                .fontWeight(.bold)
                .foregroundColor(ThemeManager.foregroundColor)
            Spacer()
        }
    }
}

struct LoginGoogleButtonContent: View {
    var body: some View {
        HStack {
            Image(Constants.ImageName.GoogleImage)
            Text(Constants.Login.googleSignIn)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showSignInView: .constant(true))
    }
}
