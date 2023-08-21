//
//  HomeNavigationView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct HomeNavigationView: View {
    
    @ObservedObject var storiesViewModel: ContentViewModel
    @Binding var bannerData: ErrorBannerModifier.BannerData
    @Binding var showMenu: Bool
    @Binding var showBanner: Bool
    @Binding var listDisabled: Bool
    @Binding var sectionListHidden: Bool
    @Binding var searchQuery: String
    @State var showSearch = false
    var showOnlyTitle: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if !showSearch {
                HStack {
                    // Menu-Icon in the navBar
                    if !showOnlyTitle {
                        Button(action: {
                            withAnimation(.spring()) {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: Constants.ImageName.horizontalLine)
                                .foregroundColor(ThemeManager.foregroundColor)
                        }
                    }
                    Spacer()
                    Text(Constants.title)
                        .font(.custom(Constants.Fonts.ArcXPFontName, size: 18))
                        .foregroundColor(ThemeManager.foregroundColor)
                    Spacer()
                    // Search icon in the navBar
                    if !showOnlyTitle {
                        Button(action: {
                            showSearch.toggle()
                            sectionListHidden.toggle()
                        }) {
                            Image(systemName: Constants.ImageName.magnifying)
                                .foregroundColor(ThemeManager.foregroundColor)
                        }
                    }
                }.padding(.bottom, 10)
            }
            // Show the search field and hide menu-bar
            if showSearch {
                VStack {
                    HStack {
                        Image(systemName: Constants.ImageName.magnifying)
                            .padding(.horizontal, 8)
                            .foregroundColor(ThemeManager.imageForegroundColor)
                        
                        TextField(Constants.TabBar.search,
                                  text: $searchQuery,
                                  onEditingChanged: { _ in
                            listDisabled = true
                        },
                                  onCommit: {
                            showBanner = false
                            storiesViewModel.prepareForSearch()
                            storiesViewModel.search(for: [searchQuery], index: storiesViewModel.currentPage) { result in
                                listDisabled = false
                                switch result {
                                case .success(let searchResults):
                                    if searchResults.isEmpty {
                                        showBanner = true
                                        bannerData = ErrorBannerModifier.BannerData(
                                            title: ErrorType.emptySearchResultTitle.rawValue,
                                            detail: ErrorType.emptySearchResultDetail.rawValue,
                                            type: .warning)
                                    }
                                case .failure(let error):
                                    showBanner = true
                                    if searchQuery.isEmpty {
                                        bannerData = ErrorBannerModifier.BannerData(title: ErrorType.emptySearchQuery.rawValue,
                                                                                    detail: error.localizedDescription,
                                                                                    type: .error)
                                    } else {
                                        bannerData = ErrorBannerModifier.BannerData(title: ErrorType.searchError.rawValue,
                                                                                    detail: error.localizedDescription,
                                                                                    type: .error)
                                    }
                                }
                            }
                        })
                        .autocapitalization(.none)
                        .cornerRadius(20)
                        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                        .onAppear {
                            if searchQuery.isEmpty {
                                listDisabled = true
                            }
                        }
                        .onDisappear {
                            listDisabled = false
                        }
                        
                        Button(action: {
                            if !searchQuery.isEmpty {
                                guard let primaryAlias = storiesViewModel.menuItems.first?.id,
                                      !primaryAlias.isEmpty else {
                                    bannerData = ErrorBannerModifier.BannerData(
                                        title: ErrorType.fetchCollectionFail.rawValue,
                                        detail: "Error in reading menu elements",
                                        type: .error)
                                    return
                                }
                                
                                storiesViewModel.fetchCollection(alias: primaryAlias,
                                                                 index: 0,
                                                                 newSection: true) { result in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(let error):
                                        showBanner = true
                                        if let contentError = error as? NetworkError {
                                            if case let .URLRequestError(reason) = contentError {
                                                if case .networkUnavailable = reason {
                                                    bannerData = ErrorBannerModifier.BannerData(
                                                        title: ErrorType.fetchCollectionFail.rawValue,
                                                        detail: ErrorType.cachedContentStale.rawValue,
                                                        type: .warning)
                                                }
                                            }
                                        } else {
                                            bannerData = ErrorBannerModifier.BannerData(
                                                title: ErrorType.fetchCollectionFail.rawValue,
                                                detail: error.localizedDescription,
                                                type: .error)
                                        }
                                    }
                                }
                            }
                            
                            searchQuery = ""
                            withAnimation {
                                showSearch.toggle()
                                sectionListHidden.toggle()
                            }
                        }) {
                            Image(systemName: Constants.ImageName.xmark).foregroundColor(ThemeManager.imageForegroundColor)
                        }
                        .padding(.horizontal, 8)
                        .foregroundColor(ThemeManager.foregroundColor)
                    }
                    .padding(10)
                    .background(ThemeManager.foregroundColor)
                    .cornerRadius(20)
                }
                // Padding for top and bottom of the navigation bar
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
        }
        .padding(.horizontal)
        .background(ThemeManager.menuBackgroundColor.ignoresSafeArea())
    }
}
