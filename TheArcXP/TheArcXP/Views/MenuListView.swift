//
//  MenuListView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct MenuListView: View {
    
    @Binding var menuItems: SectionList
    @Binding var selectedMenuItem: SectionListElement?
    @Binding var showMenu: Bool
    @Binding var showSubMenu: Bool
    @Binding var selectedSubMenuItem: SectionListElement?
    @ObservedObject var storiesViewModel: ContentViewModel
    @Binding var isLoading: Bool
    @Binding var showBanner: Bool
    @Binding var bannerData: ErrorBannerModifier.BannerData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            ThemeManager.menuBackgroundColor
            VStack(alignment: .leading) {
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
                        withAnimation(.spring()) {
                            showMenu.toggle()
                            if let children = menuItem.children, !children.isEmpty {
                                showSubMenu = true
                            } else {
                                showMenu = false
                                showSubMenu = false
                            }
                        }
                    }) {
                        VStack {
                            HStack {
                                if let title = menuItem.title {
                                    Text(title)
                                        .foregroundColor(ThemeManager.foregroundColor)
                                }
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
