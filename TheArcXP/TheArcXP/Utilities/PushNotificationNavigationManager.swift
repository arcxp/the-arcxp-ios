//
//  PushNotificationNavigationManager.swift
//  TheArcXP
//
//  Created by Amani Hunter on 8/17/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation

class PushNotificationNavigationManager: ObservableObject {
    
    static let shared = PushNotificationNavigationManager()
    @Published var navigateToDetail = false
    @Published var uuid: String?
    @Published var contentType = ""
}
