//
//  ErrorType.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 5/6/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation

enum ErrorType: String {
    case fetchCollectionFail = "Error fetching stories."
    case emptySearchResultTitle = "Search Results empty."
    case emptySearchResultDetail = "Your search query had no results."
    case fetchStoryIdErrorDetail = "There was an error fetching the story."
    case searchError = "Error fetching searched terms."
    case userProfileError = "Failed to fetch user profile."
    case createAccountError = "Error creating your account."
    case tenantConfigError = "Error while fetching the tenant configuration."
    case fetchStoryError = "Error fetching the story."
    case emptySearchQuery = "Empty search query. Please enter a valid search term."
    case cachedContentStale = "Network unavailable. Displaying content that may be stale!"
}
