//
//  TopicList.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 8/24/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

class Topic: Identifiable, ObservableObject {
    var isSubscribed = false
    var displayName: String
    var id: String
    
    init(isSubscribed: Bool = false, displayName: String, id: String) {
        self.isSubscribed = UserDefaults.standard.bool(forKey: "\(Constants.Account.toggleKey)\(id)")
        self.displayName = displayName
        // Topic strings cannot contain spaces. If spaces are subscribing to a topic will fail.
        self.id = displayName.replacingOccurrences(of: " ", with: "")
    }
}
