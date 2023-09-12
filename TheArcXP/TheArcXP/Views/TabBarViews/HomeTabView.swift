//
//  HomeTabView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

enum CollectionType {
    case story
    case video
}

struct HomeTabView: View {
    var analyticsService: AnalyticsService = .shared
    @State var animate = false
    @State var showBanner = false
    @State var showMenu = false
    @State var searchQuery = ""
    @State var bannerData: ErrorBannerModifier.BannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @State var isLoading = false
    @State var listDisabled = false
    @State var sectionListHidden = false
    @StateObject fileprivate var contentViewModel = ContentViewModel()
    var collectionType: CollectionType
    @Binding var tabSelection: Int
    @State private var showDetailViewFromWidget = false
    @State private var adsEnabled = false
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder private var loadingOverlay: some View {
        if isLoading {
                GeometryReader { geometry in
                    VStack {
                        ContentLoadingIndicator(width: geometry.size.width * 0.2,
                                                height: geometry.size.height * 0.09,
                                                $animate)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
        }
    }

    var body: some View {
        ZStack {
            ThemeManager.menuBackgroundColor
            ZStack {
                (showMenu ? ThemeManager.menuBackgroundColor.opacity(0.05) : colorScheme == .dark ?
                 ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                    .edgesIgnoringSafeArea(.all)
                ZStack(alignment: .leading) {
                    ZStack(alignment: .topLeading) {
                        VStack(spacing: 0) {
                            switch collectionType {
                            case .story:
                                HomeNavigationView(storiesViewModel: contentViewModel,
                                                   bannerData: $bannerData,
                                                   showMenu: $showMenu,
                                                   showBanner: $showBanner,
                                                   listDisabled: $listDisabled,
                                                   sectionListHidden: $sectionListHidden,
                                                   searchQuery: $searchQuery,
                                                   showOnlyTitle: false)
                                TopMenuView(menuItems: contentViewModel.menuItems,
                                            selectedMenuItem: $contentViewModel.selectedMenuItem,
                                            storiesViewModel: contentViewModel,
                                            isLoading: $isLoading,
                                            showBanner: $showBanner,
                                            bannerData: $bannerData)
                                .hidden($sectionListHidden)
                            default:
                                HomeNavigationView(storiesViewModel: contentViewModel,
                                                   bannerData: $bannerData,
                                                   showMenu: $showMenu,
                                                   showBanner: $showBanner,
                                                   listDisabled: $listDisabled,
                                                   sectionListHidden: $sectionListHidden,
                                                   searchQuery: $searchQuery,
                                                   showOnlyTitle: true)
                            }
                            GeometryReader { geometry in
                                VStack {
                                    // It's a grid view for iPad video tab
                                    if UIDevice.current.userInterfaceIdiom == .pad && collectionType == .video {
                                        ScrollView {
                                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                                ForEach(contentViewModel.fetchedCollection, id: \.identifier) { story in
                                                    VideoiPadRowView(videoContent: story)
                                                }
                                                .padding(.all, 20)

                                                if contentViewModel.noMoreContent == false {
                                                    ContentLoadingIndicator(width: geometry.size.width,
                                                                            height: geometry.size.height,
                                                                            $animate)
                                                    .onAppear {
                                                        fetchCollectionResults()
                                                    }
                                                }
                                            }
                                        }
                                    } else {    // list-view for all other
                                        List {
                                            ForEach(Array(contentViewModel.fetchedCollection.enumerated()),
                                                    id: \.element.identifier) { index, story in
                                                VStack {
                                                    if adsEnabled && canPlaceAd(atIndex: index) {
                                                        NativeAdContentView(story: story)
                                                    }
                                                    if story.type == .story {
                                                        if story.identifier == contentViewModel.fetchedCollection.first?.identifier {
                                                            ListStoryRowView(story: story,
                                                                             width: geometry.size.width,
                                                                             height: geometry.size.height,
                                                                             first: true)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        } else {
                                                            ListStoryRowView(story: story,
                                                                             width: geometry.size.width,
                                                                             height: geometry.size.height,
                                                                             first: false)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        }
                                                    } else if story.type == .video {
                                                        let storyId = contentViewModel.fetchedCollection.first?.identifier
                                                        VideoRowView(videoContent: story,
                                                                     width: geometry.size.width,
                                                                     height: geometry.size.height,
                                                                     isFirstItem: (story.identifier == storyId))
                                                    }
                                                    NavigationLink(destination: DeferView {
                                                        if story.type == .story {
                                                            StoryDetailView(story: story,
                                                                            searchQuery: $searchQuery,
                                                                            listDisabled: $listDisabled)
                                                        } else if story.type == .video {
                                                            VideoPlayerView(storyIdentfier: story.identifier)
                                                        }
                                                    }) {EmptyView()}
                                                        .frame(width: 0)
                                                        .opacity(0)
                                                        .background(colorScheme == .dark ?
                                                                    ThemeManager.darkModeBackgroundColor :
                                                                        ThemeManager.lightModeBackgroundColor)
                                                }
                                                .background(colorScheme == .dark ?
                                                            ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                                            }
                                            .listRowBackground(colorScheme == .dark ?
                                                               ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)

                                            if contentViewModel.noMoreContent == false {
                                                ContentLoadingIndicator(width: geometry.size.width,
                                                                        height: geometry.size.height,
                                                                        $animate)
                                                .onAppear {
                                                    fetchCollectionResults()
                                                }
                                            }
                                        }
                                        .background(colorScheme == .dark ?
                                                    ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                                        .listStyle(.plain)
                                    }
                                }
                                .listStyle(.plain)
                                .background(colorScheme == .dark ?
                                            ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                                .overlay(loadingOverlay)
                                .banner(data: $bannerData, show: $showBanner)
                                .onAppear {
                                    listDisabled = false
                                }
                                .disabled(listDisabled)
                            }
                            Spacer()
                        }
                        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                    }

                    ZStack(alignment: .leading) {
                        if showMenu {
                            MenuContainerView(menuItems: .constant(contentViewModel.menuItems),
                                              selectedMenuItem: $contentViewModel.selectedMenuItem,
                                              showMenu: $showMenu,
                                              storiesViewModel: contentViewModel,
                                              isLoading: $isLoading,
                                              showBanner: $showBanner,
                                              bannerData: $bannerData)
                            Spacer()
                        }
                    }
                }
            }
            if let widgetIdentifier = contentViewModel.storyIDFromWidget {
                NavigationLink(destination:
                                StoryDetailView(widgetStoryIdentifier: widgetIdentifier,
                                                searchQuery: $searchQuery,
                                                listDisabled: $listDisabled),
                               isActive: $showDetailViewFromWidget) { EmptyView() }
            }
        }
        .onAppear {
            // Fetch menu items only in home-tab, and avoid in video-tab
            // Show native ads only in home-tab
            if collectionType != .video {
                fetchMenuItems()
                AdsServiceFactory.shared.createAdsService { adsService in
                    adsEnabled = adsService.adsEnabled()
                }
                // report home screen view
                analyticsService.reportScreenView(screen: .homeScreen())
            } else {
                // report video screen view
                analyticsService.reportScreenView(screen: .videoScreen())
            }
        }
        .onOpenURL { id in
            presentStoryDetailFromWidget(id: id.absoluteString)
        }
    }

    private func fetchMenuItems() {
        guard contentViewModel.menuItems.isEmpty else {
            return
        }
        contentViewModel.getMenuItems { _ in
            fetchCollectionAliasResults()
        }
    }

    private func fetchCollectionResults() {
        if searchQuery.isEmpty {
            fetchCollectionAliasResults()
        }
    }

    private func canPlaceAd(atIndex index: Int) -> Bool {
        return (index + 1) % 5 == 0
    }

    private func fetchCollectionAliasResults() {
        
        let collectionAlias: String
        if collectionType == .story, let alias = contentViewModel.menuItems.first?.id {
            collectionAlias = alias
        } else if collectionType == .video {
            collectionAlias = Constants.Org.videoCollectionAlias
        } else {
            return
        }
        contentViewModel.fetchCollection(alias: collectionAlias,
                                         index: contentViewModel.currentPage) { result in
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
                        } else {
                            bannerData = ErrorBannerModifier.BannerData(
                                title: ErrorType.fetchCollectionFail.rawValue,
                                detail: contentError.localizedDescription,
                                type: .error)
                        }
                    } else {
                        bannerData = ErrorBannerModifier.BannerData(
                            title: ErrorType.fetchCollectionFail.rawValue,
                            detail: error.localizedDescription,
                            type: .error)
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

    private func presentStoryDetailFromWidget(id: String) {
        /*
         Setting tabSelection to 0 handles an edge case if the
         app moves to the background with a Tab other than the first HomeTabView selected.
         When a user selects a story from the widget the first HomeTabView is selected.
         */
        tabSelection = 0
        contentViewModel.storyIDFromWidget = id
        showDetailViewFromWidget = true
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView(collectionType: .story, tabSelection: .constant(0))
    }
}
