//
//  ResetPasswordView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/22/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct ResetPasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showBanner = false
    @State private var bannerData = ErrorBannerModifier.BannerData(
        title: "This is error Title",
        detail: "This is the where the error detail goes",
        type: .error)
    @State private var presentSuccessAlert = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userViewModel: UserViewModel
    
    var textFieldsValid: Bool {
        return (!currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty)
    }
    
    var buttonColor: Color {
        return textFieldsValid ? ThemeManager.authButtonColor : ThemeManager.authTextFieldsNotValidColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: geometry.size.height * 0.02) {
                Text(Constants.ResetPassword.current)
                    .padding([.top], 30)
                SecureInput(placeholder: Constants.ResetPassword.current, text: $currentPassword)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary, lineWidth: 1)
                                .foregroundColor(.clear)
                                .frame(maxHeight: geometry.size.height * 0.07))
                    .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)
                
                Text(Constants.ResetPassword.new)
                    .padding([.top])
                SecureInput(placeholder: Constants.ResetPassword.new, text: $newPassword)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary, lineWidth: 1)
                                .foregroundColor(.clear)
                                .frame(maxHeight: geometry.size.height * 0.07))
                    .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)
                
                Text(Constants.ResetPassword.confirm)
                    .padding([.top])
                SecureInput(placeholder: Constants.ResetPassword.confirm, text: $confirmPassword)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary, lineWidth: 1)
                                .foregroundColor(.clear)
                                .frame(maxHeight: geometry.size.height * 0.07))
                    .frame(maxWidth: geometry.size.width * 0.85, maxHeight: geometry.size.height * 0.07)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(alignment: .center) {
                Button(action: {
                    updatePassword()
                }) {
                    Text(Constants.ResetPassword.update)
                        .bold()
                        .frame(maxWidth: geometry.size.width * 0.75, maxHeight: geometry.size.height * 0.02)
                        .padding()
                        .background(buttonColor)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                }
                .disabled(!textFieldsValid)
            }
            .banner(data: $bannerData, show: $showBanner)
            .alert(isPresented: $presentSuccessAlert) {
                Alert(
                    title: Text("Success!"),
                    message: Text("Password has been updated."))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding([.top], 60)
        }
    }
    
    private func updatePassword() {
        guard newPassword == confirmPassword else {
            showBanner = true
            bannerData = ErrorBannerModifier.BannerData(
                title: "Failed to update password.",
                detail: "Password mismatch. Please check your new password.",
                type: .error)
            return
        }
        
        userViewModel.updatePassword(oldPass: currentPassword,
                                     newPass: newPassword) { result in
            switch result {
            case .success:
                presentSuccessAlert = true
                mode.wrappedValue.dismiss()
            case .failure(let error):
                showBanner = true
                bannerData = ErrorBannerModifier.BannerData(
                    title: "Failed to update password",
                    detail: error.localizedDescription,
                    type: .error)
            }
        }
    }
}
