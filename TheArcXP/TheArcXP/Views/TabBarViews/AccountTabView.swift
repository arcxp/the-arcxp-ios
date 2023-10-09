//
//  SettingsTabView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct AccountTabView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var userViewModel = UserViewModel()
    @State private var showBanner = false
    @State var refresh: Bool = false
    @State var showSignInControl: Bool = Commerce.cachedUserProfile == nil
    @State private var bannerData = ErrorBannerModifier.BannerData(
        title: "",
        detail: "",
        type: .error)
    // These below state vars do nothing and used only for instantiating the HomeNavigationView.
    @State var showMenu = false
    @State var searchQuery = ""
    @State var listDisabled = false
    @State var sectionListHidden = false
    @StateObject fileprivate var contentViewModel = ContentViewModel()
    private var analyticsService: AnalyticsService = .shared
    
    fileprivate func getMenuItems() -> SectionList {
        contentViewModel.getMenuItems { result in
            guard result.value != nil else { return }
        }
        return contentViewModel.menuItems
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HomeNavigationView(storiesViewModel: contentViewModel,
                               bannerData: $bannerData,
                               showMenu: $showMenu,
                               showBanner: $showBanner,
                               listDisabled: $listDisabled,
                               sectionListHidden: $sectionListHidden,
                               searchQuery: $searchQuery,
                               showOnlyTitle: true)
            
            List {
                Text(Constants.Account.account)
                    .font(.subheadline)
                    .foregroundColor(ThemeManager.listHeaderColor)
                    .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                if Commerce.cachedUserProfile == nil && showSignInControl {
                    // A user is not signed in
                    NavigationLink(destination: CreateAccountView().navigationBarHidden(true)) {
                        HStack {
                            Text(Constants.Account.createAccount)
                                .foregroundColor(colorScheme == .dark ?
                                                 ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            Spacer()
                        }
                        .padding([.top, .bottom])
                    }
                    .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                    
                    NavigationLink(destination: SignInView(showSignInView: $showSignInControl).navigationBarHidden(true)) {
                        HStack {
                            Text(Constants.Account.login)
                                .foregroundColor(colorScheme == .dark ?
                                                 ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            Spacer()
                        }
                        .padding([.top, .bottom])
                    }
                    .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                } else {
                    // A user is signed in
                    VStack(alignment: .leading) {
                        if let first = userViewModel.user?.firstName, let last = userViewModel.user?.lastName {
                            Text(first + " " + last)
                                .foregroundColor(ThemeManager.authButtonColor)
                                .bold()
                                .padding([.top])
                        }
                        
                        Text(Constants.Account.subscriber)
                            .font(.caption)
                            .foregroundColor(ThemeManager.listHeaderColor)
                            .padding([.bottom])
                    }
                    .onAppear {
                        userViewModel.fetchUser { userResult in
                            switch userResult {
                            case .success:
                                break
                            case .failure(let error):
                                showBanner = true
                                bannerData = ErrorBannerModifier.BannerData(
                                    title: ErrorType.userProfileError.rawValue,
                                    detail: error.localizedDescription,
                                    type: .error)
                            }
                        }
                    }
                    
                    NavigationLink(destination: ResetPasswordView(userViewModel: userViewModel)) {
                        HStack {
                            Text(Constants.Account.changePass)
                                .foregroundColor(colorScheme == .dark ?
                                                 ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            Spacer()
                        }
                        .padding([.top, .bottom])
                    }
                    
                    Button(action: {
                        Commerce.logOut()
                        showSignInControl = true
                        refresh.toggle()
                    }) {
                        HStack {
                            Text(Constants.Account.logout)
                                .foregroundColor(colorScheme == .dark ?
                                                 ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            Spacer()
                        }
                        .padding([.top, .bottom])
                    }
                }
                
                Text(Constants.Account.policy)
                    .font(.subheadline)
                    .foregroundColor(ThemeManager.listHeaderColor)
                    .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                Button(action: {
                    openURL(URL(string: Constants.PrivacyPolicy.termsServiceUrl)!)
                }) {
                    HStack {
                        Text(Constants.Account.terms)
                            .foregroundColor(ThemeManager.listHeaderColor)
                        Spacer()
                        Image(systemName: Constants.ImageName.chevronRight)
                            .foregroundColor(ThemeManager.imageForeground)
                    }
                    .padding([.top, .bottom])
                }
                .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                
                Button(action: {
                    openURL(URL(string: Constants.PrivacyPolicy.privacyPolicyUrl)!)
                }) {
                    HStack {
                        Text(Constants.Account.policy)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        Spacer()
                        Image(systemName: Constants.ImageName.chevronRight)
                            .foregroundColor(ThemeManager.imageForeground)
                    }
                    .padding([.top, .bottom])
                }
                .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                
                NavigationLink(destination:
                                NotificationSettingsView(viewModel: NotificationSettingsViewModel(sectionList: contentViewModel.menuItems.isEmpty ? getMenuItems() : contentViewModel.menuItems))) {
                    Text(Constants.Account.notificationSettings)
                }
                .padding([.top, .bottom])
                
                VStack {
                    Text(Constants.Account.softwareVersion)
                        .foregroundColor(colorScheme == .dark ? ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                        .padding([.top, .bottom])
                    VStack(alignment: .leading) {
                        
                        Text("App: \(Bundle.main.appVersionLong)")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .padding(5)
                        Text("Content: \(ArcXPContentManager.version)")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .padding(5)
                        Text("Commerce: \(Commerce.version)")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .padding(5)
                        Text("Video SDK: \(ArcMediaPlayerSDK.versionString)")
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeLabelTextColor : ThemeManager.lightModeLabelTextColor)
                            .padding(5)
                    }
                }
                .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
            }
            .id(refresh)
            .listStyle(.plain)
            Spacer()
        }
        .onAppear {
            analyticsService.reportScreenView(screen: .accountScreen())
        }
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
        .banner(data: $bannerData, show: $showBanner)
    }
}

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
    }
}
