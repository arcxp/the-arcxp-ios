//
//  NotificationSettingsViewModel.swift
//  TheArcXP
//
//  Created by Amani Hunter on 9/15/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP
import FirebaseMessaging

class NotificationSettingsViewModel: ObservableObject {
    
    @Published var topicList: [Topic]
    @Published var showSubAllToggle = UserDefaults.standard.bool(forKey: Constants.Account.subToAllKey)
    private let subscriptionsLogger = Logger(label: "NotificationSettingsViewModel")
    
    init(sectionList: SectionList) {
        topicList = sectionList.filter { $0.name != nil }.map({ section in
            Topic(displayName: section.title ?? "", id: section.id ?? "")
        })
        loadToggleStates()
    }
    
    func subscribeToTopic(topic: Topic) {
        Messaging.messaging().subscribe(toTopic: topic.id) { error in
            guard let error = error else {
                self.subscriptionsLogger.info("Subscribed to topic: \(topic.displayName), ID: \(topic.id)")
                self.saveToggleState(isSubscribed: true, key: "\(Constants.Account.toggleKey)\(topic.id)")
                return
            }
            self.subscriptionsLogger.error("Failed to subscribe to topic with error: \(error)")
            // Change toggle state back to off
            self.saveToggleState(isSubscribed: false, key: "\(Constants.Account.toggleKey)\(topic.id)")
        }
    }
    
    func unsubscribeToTopic(topic: Topic) {
        Messaging.messaging().unsubscribe(fromTopic: topic.id) { error in
            guard let error = error else {
                self.subscriptionsLogger.info("Unsubscribed from topic: \(topic.displayName), ID: \(topic.id)")
                self.saveToggleState(isSubscribed: false, key: "\(Constants.Account.toggleKey)\(topic.id)")
                return
            }
            self.subscriptionsLogger.error("Failed to unsubscribe from topic with error: \(error)")
            // Change toggle state back to on
            self.saveToggleState(isSubscribed: true, key: "\(Constants.Account.toggleKey)\(topic.id)")
        }
    }
    
    func handleTopics(topics: [Topic], isSubscribing: Bool) {
        let dispatchGroup = DispatchGroup()
        for topic in topics {
            dispatchGroup.enter()
            if isSubscribing {
                Messaging.messaging().subscribe(toTopic: topic.id) { error in
                    defer {
                        dispatchGroup.leave()
                    }
                    guard let error = error else {
                        self.subscriptionsLogger.info("Subscribed to topic: \(topic.displayName). ID: \(topic.id)")
                        return
                    }
                    self.subscriptionsLogger.error("Failed to subscribe to topic with error: \(error)")
                }
            } else {
                Messaging.messaging().unsubscribe(fromTopic: topic.id) { error in
                    defer {
                        dispatchGroup.leave()
                    }
                    guard let error = error else {
                        self.subscriptionsLogger.info("Unsubscribed from topic: \(topic.displayName). ID: \(topic.id)")
                        return
                    }
                    self.subscriptionsLogger.error("Failed to unsubscribe from topic with error: \(error)")
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            // This block is executed when all operations are completed.
            self.saveToggleState(isSubscribed: isSubscribing, key: Constants.Account.subToAllKey)
        }
    }
    
    func loadToggleStates() {
        topicList.forEach { topic in
            let isSubscribed = UserDefaults.standard.bool(forKey: "\(Constants.Account.toggleKey)\(topic.id)")
            topic.isSubscribed = isSubscribed
        }
    }
    
    func saveToggleState(isSubscribed: Bool, key: String) {
        UserDefaults.standard.set(isSubscribed, forKey: key)
    }
}
