//
//  StoryDetailView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/8/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct StoryDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    private var story: ArcXPContent?
    @State private var storyMetadata = ContentMetadata(keywords: [], articleURL: "")
    private var widgetStoryIdentifier: String?
    private var pushNotificationUUID: String?
    @State private var storyContent: ArcXPContent?
    @State private var showBanner = false
    @State private var bannerData = ErrorBannerModifier.BannerData(title: "", detail: "", type: .error)
    @StateObject private var storiesViewModel = ContentViewModel()
    @Binding private var searchQuery: String
    @Binding private var listDisabled: Bool
    @State private var showPaywallScreen: Bool = false
    @State private var adsEnabled: Bool = false
    @Binding var tabBarVisibility: Visibility
    private var analyticsService: AnalyticsService = .shared

    init(story: ArcXPContent? = nil, widgetStoryIdentifier: String? = nil, pushNotificationUUID: String? = nil,
         searchQuery: Binding<String>, listDisabled: Binding<Bool>, tabBarVisibility: Binding<Visibility> = .constant(Visibility.hidden)) {
        NavigationBarTheme.navigationBarColors(background: ThemeManager.navigationBarUIKitBackgroundColor,
                                               titleColor: ThemeManager.navigationBarTextColor)
        self.story = story
        self.widgetStoryIdentifier = widgetStoryIdentifier
        self.pushNotificationUUID = pushNotificationUUID
        _searchQuery = searchQuery
        _listDisabled = listDisabled
        _tabBarVisibility = tabBarVisibility
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    if adsEnabled {
                        // Show ad view
                        BannerAdContentView(metaData: storyMetadata, height: setAdHeight(size: geo.size))
                    }
                    Text(storyContent?.taxonomy?.primarySection?.name ?? Constants.Story.news)
                        .bold()
                        .foregroundColor(colorScheme == .dark ?
                                         ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                        .padding([.leading, .trailing, .top])
                        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                    Text(storyContent?.headlines?.basic ?? "")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(colorScheme == .dark ?
                                         ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                        .padding([.leading, .trailing, .bottom])
                        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)

                    if let subheadline = storyContent?.subheadlines?.basic {
                        Text(subheadline)
                            .foregroundColor(ThemeManager.secondaryTextColor)
                            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                            .font(.title2)
                            .padding([.leading, .trailing])
                    }

                    if let imageUrl = SDKUtils.getResizeImageUrl(imageContentElement: storyContent?.promoItems?.content),
                       !imageUrl.isEmpty {
                        ImageView(withURL: imageUrl)
                            .padding([.leading, .trailing])
                    }

                    if let authors = SDKUtils.formattedAuthorNamesText(storyContent?.authorNames) {
                        Text(authors)
                            .foregroundColor(colorScheme == .dark ?
                                             ThemeManager.darkModeContentTextColor : ThemeManager.lightModeContentTextColor)
                            .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                            .padding([.leading, .trailing])
                    }

                    if let publishedDate = SDKUtils.formattedDateWithTimeZone(dateString: storyContent?.publishDate),
                       !publishedDate.isEmpty {
                        Text(publishedDate)
                            .foregroundColor(ThemeManager.secondaryTextColor)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(Constants.CreateAccount.done) {
                            // if the searchQuery is not empty i.e. search mode is enabled
                            // query for the same search result using the same search query,
                            // and then dismiss. Otherwise dismiss as normal.
                            if !searchQuery.isEmpty {
                                storiesViewModel.search(for: [searchQuery]) { result in
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
                                        bannerData = ErrorBannerModifier.BannerData(title: ErrorType.searchError.rawValue,
                                                                                    detail: error.localizedDescription,
                                                                                    type: .error)
                                    }
                                }
                            }
                            tabBarVisibility = .visible
                            mode.wrappedValue.dismiss()
                        }
                    }
                    
                    if let shareUrl = constructShareURL(canonicalUrl: story?.canonicalUrl) {
                        ToolbarItem(placement: .topBarTrailing) {
                            ShareLink(item: shareUrl)
                        }
                    }
                }
                .onAppear {
                    if let story = story {
                        storyContent = story
                        storyMetadata.updateArticleMetadata(content: story)
                    if let storyID = story.identifier {
                        fetchStory(id: storyID)
                    } else {
                        showBanner = true
                        bannerData = ErrorBannerModifier.BannerData(title: ErrorType.fetchStoryError.rawValue,
                                                                    detail: ErrorType.fetchStoryIdErrorDetail.rawValue,
                                                                    type: .error)
                    }
                    } else if let widgetStoryIdentifier = widgetStoryIdentifier {
                        fetchStory(id: widgetStoryIdentifier)
                    } else if let pushNotificationUUID {
                        fetchStory(id: pushNotificationUUID)
                    }
                    AdsServiceFactory.shared.createAdsService { adsService in
                        adsEnabled = adsService.adsEnabled()
                    }
                }

                if let contents = storyContent?.contentElements {
                    let articleWidth = geo.size.width > geo.size.height ? geo.size.height * 2 : geo.size.width
                    ArticleBodyView(contentElements: contents, width: articleWidth, height: geo.size.height)
                }
                if adsEnabled {
                    // Show ad view
                    BannerAdContentView(metaData: storyMetadata, height: setAdHeight(size: geo.size))
                }
            }
            .onAppear {
                analyticsService.reportScreenView(screen: .articleScreen())
                tabBarVisibility = .hidden
            }
            .banner(data: $bannerData, show: $showBanner)
            .paywall(isShowing: $showPaywallScreen)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .background(colorScheme == .dark ?
                        ThemeManager.darkModeBackgroundColor.ignoresSafeArea() : ThemeManager.lightModeBackgroundColor.ignoresSafeArea())
        }
        .accentColor(ThemeManager.navigationBarButtonColor)
    }

    private func fetchStory(id: String) {
        showPaywallScreen = PaywallLoader.shouldShowPaywall(contentID: id, contentType: .story)
        
        // If paywall screen is shown, avoid proceeding further
        guard !showPaywallScreen else {
            return
        }
        storiesViewModel.fetchStory(id: id) { result in
            switch result {
            case .success(let story):
                self.storyContent = story
            case .failure(let error):
                showBanner = true
                if let contentError = error as? NetworkError {
                    if case let .URLRequestError(reason) = contentError {
                        if case let .networkUnavailable(cachedContent) = reason {
                            if let content = cachedContent as? ArcXPContent {
                                storyContent = content
                            }

                            bannerData = ErrorBannerModifier.BannerData(
                                title: ErrorType.fetchStoryError.rawValue,
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
                        title: ErrorType.fetchStoryError.rawValue,
                        detail: error.localizedDescription,
                        type: .error)
                }
            }
        }
    }
    
    private func setAdHeight(size: CGSize) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return size.height / 6.5
        }
        return size.height / 8
    }
    
    private func constructShareURL(canonicalUrl: String?) -> String? {
        guard let canonicalUrl = canonicalUrl else { return nil }
        return "https://\(Constants.Org.contentDomain)\(canonicalUrl)"
    }
}
