//
//  ForgotPasswordView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 4/27/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var errString: String?
    @State private var showBanner = false
    @State private var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text(Constants.ForgotPassword.emailRequest)
                    .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                TextField(Constants.ForgotPassword.enterEmail, text: $email).autocapitalization(.none).keyboardType(.emailAddress)
                Button(action: {
                    userViewModel.requestResetPassword(email: email) { result in
                        showBanner = true
                        switch result {
                        case .success:
                            bannerData = ErrorBannerModifier.BannerData(
                                title: Constants.ForgotPassword.emailSent,
                                detail: Constants.ForgotPassword.emailCheck,
                                type: .success)
                        case .failure(let error):
                            bannerData = ErrorBannerModifier.BannerData(
                                title: Constants.ForgotPassword.emailFail,
                                detail: error.localizedDescription,
                                type: .error)
                        }
                    }
                }) {
                    Text(Constants.ForgotPassword.emailReset)
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(ThemeManager.resetPasswordButtonColor)
                        .cornerRadius(8)
                        .foregroundColor(ThemeManager.buttonForegroundColor)
                }
                Spacer()
            }
            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
            .banner(data: $bannerData, show: $showBanner)
            .padding(.top)
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationBarTitle(Constants.title,
                                displayMode: .inline)
            .navigationBarItems(trailing: Button(Constants.ForgotPassword.dismiss) {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView(userViewModel: UserViewModel())
    }
}
