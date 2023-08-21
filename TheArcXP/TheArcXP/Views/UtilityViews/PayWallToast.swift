//
//  PayWallToast.swift
//  TheArcXP
//
//  Created by Soldier Williams on 5/25/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    @State var navigateToCreateAccount = false
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                Color.black.opacity(0.60)
                VStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            UIKitNavigation.popToRootView()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: Constants.ImageName.xmark)
                                    .foregroundColor(ThemeManager.imageForegroundColor)
                            }
                        }
                        HStack {
                            NavigationLink(destination: CreateAccountView().navigationBarBackButtonHidden(true)) {
                                Text(Constants.Account.createAccount)
                                    .foregroundColor(ThemeManager.buttonColor)
                            }
                            Text(PaywallConstants.continueReading)
                                .foregroundColor(ThemeManager.paywallToastTextColor)
                        }
                        HStack {
                            Text(Constants.CreateAccount.existingAccount)
                                .foregroundColor(ThemeManager.paywallToastTextColor)
                            NavigationLink(destination: SignInView()) {
                                Text(Constants.Login.signIn)
                                    .foregroundColor(ThemeManager.buttonColor)
                            }
                        }
                        .padding(.bottom)
                        Text(PaywallConstants.getEveryStory)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .foregroundColor(ThemeManager.paywallToastTextColor)
                        NavigationLink(Constants.Account.createAccount,
                                       destination: CreateAccountView().navigationBarHidden(true),
                                       isActive: $navigateToCreateAccount)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75,
                                   maxHeight: UIScreen.main.bounds.height * 0.02)
                            .padding()
                            .background(ThemeManager.paywallToastBackgroundColor)
                            .foregroundColor(ThemeManager.paywallToastForegroundColor)
                            .padding()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(ThemeManager.secondaryBackgroundColor)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    func paywall(isShowing: Binding<Bool>) -> some View {
        modifier(ToastModifier(isShowing: isShowing))
    }
}
