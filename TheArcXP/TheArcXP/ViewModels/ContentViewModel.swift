//
//  ContentViewModel.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/6/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI
import ArcXP
import Combine

class ContentViewModel: ObservableObject {
    @Published var fetchedCollection = ArcXPContentList()
    @Published var searchQuery = ""
    @Published var menuItems: SectionList = []
    @Published var selectedMenuItem: SectionListElement?
    @Published var storyIDFromWidget: String?
    var firstInCollection: ArcXPContent?
    var dateString = ""
    var author = ""
    var noMoreContent = false
    @Published var isLoading = false
    var currentPage = 0

    func fetchCollection(alias: String,
                         index: Int,
                         size: Int = 20,
                         newSection: Bool = false,
                         completion: @escaping ArcXPCollectionResultHandler) {
        isLoading = true
        ArcXPContentManager.client.getCollection(alias: alias, index: index, size: size) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
             switch result {
             case .success(let collections):
                 if !newSection {
                     self.currentPage += size
                     self.fetchedCollection.append(contentsOf: collections)

                     if alias == self.menuItems.first?.name {
                         self.firstInCollection = collections.first
                     }
                 } else {
                     self.fetchedCollection = collections
                     self.firstInCollection = collections.first
                     self.currentPage = 20
                 }

                 if collections.count < 20 {
                     self.noMoreContent = true
                     self.currentPage = 0
                 }
                 completion(.success(collections))
             case .failure(let error):
                 self.noMoreContent = true
                 if let contentError = error as? NetworkError {
                     if case let .URLRequestError(reason) = contentError {
                         if case let .networkUnavailable(cachedContent) = reason {
                             if let content = cachedContent as? ArcXPContentList {
                                 self.fetchedCollection = content
                             }
                         }
                     }
                 }
                 completion(.failure(error))
             }
         }
    }

    func search(for keywords: [String], index: Int = 0, size: Int = 20, completion: @escaping ArcXPCollectionResultHandler) {
        ArcXPContentManager.client.search(by: keywords, index: index, size: size) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                if !searchResults.isEmpty {
                    self.fetchedCollection.append(contentsOf: searchResults)
                    self.currentPage += size
                }

                if searchResults.count < 20 {
                    self.noMoreContent = true
                    self.currentPage = 0
                }
                completion(.success(searchResults))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func prepareForSearch() {
        noMoreContent = false
        currentPage = 0
        fetchedCollection = ArcXPContentList()
    }

    func fetchStory(id: String, completion: @escaping ArcXPStoryResultHandler) {
        ArcXPContentManager.client.getStoryContent(identifier: id) { result in
            completion(result)
        }
    }
    
    func getMenuItems(completion: @escaping ArcXPSectionListHandler) {
        ArcXPContentManager.client.getSectionList(siteHierarchy: Constants.Org.siteHierarchyName) { [weak self] result in
            switch result {
            case .success(let sectionList):
                self?.menuItems = sectionList
            case .failure(let error):
                print(error.localizedDescription)
                if let contentError = error as? NetworkError {
                    if case let .URLRequestError(reason) = contentError {
                        if case let .networkUnavailable(cachedContent) = reason {
                            if let content = cachedContent as? SectionList {
                                self?.menuItems = content
                            }
                        }
                    }
                }
            }
            if self?.selectedMenuItem == nil, let item = self?.menuItems.first {
                            self?.selectedMenuItem = item
                        }
            completion(result)
        }
    }
    
    func fetchStoriesCollectionForWidget(alias: String, index: Int, size: Int, completion: @escaping ArcXPCollectionResultHandler) {
        ArcXPContentManager.client.getCollection(alias: alias, index: 0, size: size) { result in
            switch result {
            case .success(let stories):
                completion(.success(stories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
   func fetchSectionsForWidget(completion: @escaping ArcXPSectionListHandler) {
       ArcXPContentManager.client.getSectionList(siteHierarchy: Constants.Org.siteHierarchyName) { result in
           switch result {
           case .success(let sectionList):
               completion(.success(sectionList))
           case .failure(let error):
               completion(.failure(error))
           }
       }
    }
}
