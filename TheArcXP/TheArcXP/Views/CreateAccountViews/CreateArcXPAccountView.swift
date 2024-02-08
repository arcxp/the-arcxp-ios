//
//  CreateArcXPAccountView.swift
//  the-arcxp-iOS
//
//  Created by Cassandra Balbuena on 3/10/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct CreateArcXPAccountView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var willShowArcXPSignInView = false
    @State var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @State var showBanner = false
    @State var shouldLoad = false

    @State private var willShowSuccessfulSignUp = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    private var userSignUpModel = UserProfile()
    private var analyticsService: AnalyticsService = .shared

    init() {
        NavigationBarTheme.navigationBarColors(background: ThemeManager.navigationBarUIKitBackgroundColor,
                                               titleColor: ThemeManager.navigationBarTextColor)
    }

    var textFieldsValid: Bool {
        return (!firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty)
    }

    var buttonColor: Color {
        return textFieldsValid ? ThemeManager.authButtonColor : ThemeManager.authTextFieldsNotValidColor
    }

    var body: some View {
        ZStack {
            ThemeManager.secondaryBackgroundColor.ignoresSafeArea(.all)
                .navigationBarTitle(Constants.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(Constants.Account.cancel) {
                            mode.wrappedValue.dismiss()
                        }
                    }
                }
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: geometry.size.height * 0.02) {
                    Text(Constants.Account.createAccount)
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .bold()
                        .padding([.top])
                        .frame(maxHeight: geometry.size.height * 0.07)

                    VStack(spacing: geometry.size.height * 0.02) {
                        Text(Constants.CreateAccount.name)
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .bold()
                            .padding([.trailing], geometry.size.width * 0.72)

                        TextField(Constants.CreateAccount.firstName, text: $firstName)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.secondary, lineWidth: 1)
                                        .foregroundColor(.clear)
                                        .frame(maxHeight: geometry.size.height * 0.07))
                            .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)

                        TextField(Constants.CreateAccount.lastName, text: $lastName)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.secondary, lineWidth: 1)
                                        .foregroundColor(.clear)
                                        .frame(maxHeight: geometry.size.height * 0.07))
                            .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)
                    }

                    Text(Constants.CreateAccount.address)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .bold()
                        .padding([.trailing], geometry.size.width * 0.55)

                    TextField(Constants.CreateAccount.email, text: $email)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary, lineWidth: 1)
                                    .foregroundColor(.clear)
                                    .frame(maxHeight: geometry.size.height * 0.07))
                        .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)
                        .autocapitalization(.none)

                    Text(Constants.CreateAccount.password)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .bold()
                        .padding([.trailing], geometry.size.width * 0.65)

                    SecureInput(placeholder: Constants.CreateAccount.password, text: $password)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.secondary, lineWidth: 1)
                                    .foregroundColor(.clear)
                                    .frame(maxHeight: geometry.size.height * 0.07))
                        .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)

                    VStack {
                        NavigationLink(destination: LoadingView(), isActive: $shouldLoad) { EmptyView() }
                        NavigationLink(destination: CreateAccountSuccessView().navigationBarBackButtonHidden(true),
                                       isActive: $willShowSuccessfulSignUp) { EmptyView() }

                    }

                    Button(action: {
                        // The button will only become enabled if all fields are filled out
                        // thus, the fields will not be nil.
                        userSignUpModel.firstName = firstName
                        userSignUpModel.lastName = lastName
                        userSignUpModel.setUp(withRequiredFields: email, password: password, email: email)
                        shouldLoad = true

                        Commerce.Identity.signUp(user: userSignUpModel) { result in
                            shouldLoad = false
                            switch result {
                            case .success:
                                shouldLoad = false
                                willShowSuccessfulSignUp = true
                                analyticsService.report(event: .userSignUp(signUpType: LoginSignUpType.arcxp))
                            case .failure(let error):
                                shouldLoad = false
                                showBanner = true
                                bannerData = ErrorBannerModifier.BannerData(title: ErrorType.createAccountError.rawValue,
                                                                            detail: error.localizedDescription,
                                                                            type: .error)
                            }
                        }
                    }) {
                        Text(Constants.Account.createAccount)
                            .bold()
                            .frame(maxWidth: geometry.size.width * 0.75, maxHeight: geometry.size.height * 0.02)
                            .padding()
                            .background(buttonColor)
                            .cornerRadius(15)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .disabled(!textFieldsValid)
                    
                    Text("By creating an account you agree to our [Terms of Service](https://www.washingtonpost.com/terms-of-service/2011/11/18/gIQAldiYiN_story.html), [Privacy Policy](https://www.washingtonpost.com/privacy-policy/2011/11/18/gIQASIiaiN_story.html) and Community Policy")
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .multilineTextAlignment(.center)
                        .tint(ThemeManager.buttonColor)
                        .padding()

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
                .banner(data: $bannerData, show: $showBanner)
                .onAppear {
                    Commerce.Identity.getConfig { result in
                        switch result {
                        case .success(let configOptions):
                            print(configOptions)
                        case .failure(let error):
                            showBanner = true
                            bannerData = ErrorBannerModifier.BannerData(title: ErrorType.tenantConfigError.rawValue,
                                                                        detail: error.localizedDescription,
                                                                        type: .error)
                        }
                    }
                }
            }
            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
        }
    }
}

struct CreateArcXPAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateArcXPAccountView()
    }
}
