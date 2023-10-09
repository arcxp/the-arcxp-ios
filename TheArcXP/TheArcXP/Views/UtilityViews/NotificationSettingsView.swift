//
//  NotificationSettingsView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/28/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP

struct NotificationSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: NotificationSettingsViewModel
    
    private var notificationsView: some View {
        let notificationsForm = Form {
            if #available(iOS 16, *) {
                topicsToggleView
                subAllToggleView
            } else {
                singleToggleView
            }
        }
        return notificationsForm
    }
    
    private var topicsToggleView: some View {
        Section(Constants.Account.subToTopics) {
            ForEach($viewModel.topicList) { $topic in
                Toggle(topic.displayName, isOn: $topic.isSubscribed)
                    .tint(.blue)
                    .onChange(of: topic.isSubscribed) { newValue in
                        if newValue {
                            // subscribe to the topic
                            viewModel.subscribeToTopic(topic: topic)
                        } else {
                            viewModel.unsubscribeToTopic(topic: topic)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private var subAllToggleView: some View {
        if #available(iOS 16, *) {
            Section(Constants.Account.options) {
                // 'init(_:sources:isOn:)' is only available in iOS 16.0 or newer
                Toggle(Constants.Account.subToAll, sources: $viewModel.topicList, isOn: \.isSubscribed)
                    .tint(.blue)
            }
        }
    }
    
    private var singleToggleView: some View {
        Section(Constants.Account.allowNotifications) {
            Toggle(Constants.Account.subToAll, isOn: $viewModel.showSubAllToggle)
                .tint(.blue)
                .onChange(of: viewModel.showSubAllToggle) { newValue in
                    viewModel.handleTopics(topics: viewModel.topicList, isSubscribing: newValue)
                }
        }
    }
    
    var body: some View {
        VStack {
            Text(Constants.Account.notificationSettings)
                .font(.headline)
                .foregroundColor(ThemeManager.listHeaderColor)
                .listRowBackground(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
                .padding()
            notificationsView
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    struct Preview: View {
        var sectionList: SectionList?
        
        init() {
            sectionList = getSectionListData() ?? []
        }
        
        var body: some View {
            NavigationView {
                NotificationSettingsView(viewModel: NotificationSettingsViewModel(sectionList: sectionList ?? []))
            }
        }
        
        func getSectionListData() -> SectionList? {
            guard let url = Bundle.main.url(forResource: "sectionlist", withExtension: "json"),
                  let data = try? Data(contentsOf: url)
            else {
                return nil
            }
            do {
                let jsonDescription = try JSONDecoder().decode(SectionList.self, from: data)
                return jsonDescription
            } catch {
                return nil
            }
        }
    }
    
    static var previews: some View {
        Preview()
    }
}
