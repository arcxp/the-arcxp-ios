//
//  TopMenuView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

/// Segmented bar with a list of Section items
struct TopMenuView: View {
    
    let menuItems: SectionList
    @Binding var selectedMenuItem: SectionListElement?
    @ObservedObject var storiesViewModel: ContentViewModel
    @Binding var isLoading: Bool
    @Binding var showBanner: Bool
    @Binding var bannerData: ErrorBannerModifier.BannerData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(menuItems, id: \.id) { menuItem in
                        Button(action: {
                            selectedMenuItem = menuItem
                            // once user taps on a section, direct back to the corresponding section in the home tab
                            guard let menuId = menuItem.id else { return }
                            
                            isLoading = true
                            storiesViewModel.fetchCollection(alias: menuId,
                                                             index: 0,
                                                             newSection: true) { result in
                                switch result {
                                case .success:
                                    isLoading = false
                                case .failure(let error):
                                    isLoading = false
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
                        }) {
                            HStack {
                                if let title = menuItem.title {
                                    Text(title)
                                        .font(selectedMenuItem?.title == title ? .title2 : .title3)
                                        .padding(.leading)
                                        .foregroundColor(selectedMenuItem?.title == title ?
                                                         ThemeManager.foregroundColor : ThemeManager.topMenuDeselectedItem)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 7)
            .background(ThemeManager.menuBackgroundColor)
        }
    }
}
