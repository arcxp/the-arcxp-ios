//
//  CreateAccountSuccessView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/15/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct CreateAccountSuccessView: View {
    @State private var shouldLoadSignInClose = false
    @State private var shouldLoadSignInButton = false
    @Environment(\.colorScheme) var colorScheme
    
    init() {
        NavigationBarTheme.navigationBarColors(background: ThemeManager.navigationBarUIKitBackgroundColor,
                                               titleColor: ThemeManager.navigationBarTextColor)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ThemeManager.secondaryBackgroundColor.ignoresSafeArea(.all)
                    .navigationTitle(Constants.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading:
                            Button(Constants.Login.close) {
                                UIKitNavigation.popToRootView()
                            }
                    )
                
                VStack {
                    Image(systemName: Constants.ImageName.checkmark)
                        .resizable()
                        .frame(maxWidth: geometry.size.width * 0.1, maxHeight: geometry.size.height * 0.05)
                        .foregroundColor(ThemeManager.successGreen)
                        .padding([.top])
                    
                    Text(Constants.CreateAccount.success)
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .bold()
                    
                    Text(Constants.CreateAccount.created)
                        .foregroundColor(ThemeManager.secondaryTextColor)
                        .padding()
                    
                    NavigationLink(destination: SignInView().navigationBarHidden(true),
                                   isActive: $shouldLoadSignInButton) {
                        Text(Constants.Login.signIn)
                            .bold()
                            .frame(maxWidth: geometry.size.width * 0.75, maxHeight: geometry.size.height * 0.02)
                            .padding()
                            .background(ThemeManager.authButtonColor)
                            .cornerRadius(15)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CreateAccountSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountSuccessView()
    }
}
