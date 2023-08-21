//
//  MenuContainerView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct MenuContainerView: View {
    
    @Binding var menuItems: SectionList
    @Binding var selectedMenuItem: SectionListElement?
    @Binding var showMenu: Bool
    @State var showSubMenu = false
    @State var selectedSubMenuItem: SectionListElement?
    @ObservedObject var storiesViewModel: ContentViewModel
    @Binding var isLoading: Bool
    @Binding var showBanner: Bool
    @Binding var bannerData: ErrorBannerModifier.BannerData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    }) {
                        Image(systemName: Constants.ImageName.xmark)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .padding()
                    Spacer()
                    Text(selectedMenuItem?.title ?? Constants.title)
                        .foregroundColor(ThemeManager.foregroundColor)
                        .opacity(showMenu ? 1 : 0)
                        .font(.custom(Constants.Fonts.ArcXPFontName, size: 18))
                    Spacer()
                    Button(action: {
                        // settings button?
                    }) {
                        Image(systemName: Constants.ImageName.gear)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .padding()
                }
                .offset(y: -10)
                VStack {
                    MenuListView(menuItems: $menuItems,
                                 selectedMenuItem: $selectedMenuItem,
                                 showMenu: $showMenu,
                                 showSubMenu: $showSubMenu,
                                 selectedSubMenuItem: $selectedSubMenuItem,
                                 storiesViewModel: storiesViewModel,
                                 isLoading: $isLoading,
                                 showBanner: $showBanner,
                                 bannerData: $bannerData)
                    Spacer()
                }
            }
            .background(ThemeManager.menuBackgroundColor)
            .frame(width: UIScreen.main.bounds.width / 2)
        } else {
            VStack {
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    }) {
                        Image(systemName: Constants.ImageName.xmark)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Text(selectedMenuItem?.title ?? Constants.title)
                        .foregroundColor(ThemeManager.foregroundColor)
                        .opacity(showMenu ? 1 : 0)
                        .font(.custom(Constants.Fonts.ArcXPFontName, size: 18))
                    Spacer()
                    Button(action: {
                        // settings button?
                    }) {
                        Image(systemName: Constants.ImageName.gear)
                            .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .padding()
                }
                .offset(y: -10)
                VStack {
                    MenuListView(menuItems: $menuItems,
                                 selectedMenuItem: $selectedMenuItem,
                                 showMenu: $showMenu,
                                 showSubMenu: $showSubMenu,
                                 selectedSubMenuItem: $selectedSubMenuItem,
                                 storiesViewModel: storiesViewModel,
                                 isLoading: $isLoading,
                                 showBanner: $showBanner,
                                 bannerData: $bannerData)
                    Spacer()
                }
            }
            .background(ThemeManager.menuBackgroundColor)
        }
    }
}
