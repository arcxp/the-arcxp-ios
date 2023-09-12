//
//  IntentHandler.swift
//  Widget
//
//  Created by Amani Hunter on 1/30/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Intents
import ArcXP

class IntentHandler: INExtension, SelectSectionIntentHandling {
  
    func resolveSection(for intent: SelectSectionIntent, with completion: @escaping (StorySectionResolutionResult) -> Void) {}
    
    func provideSectionOptionsCollection(for intent: SelectSectionIntent,
                                         with completion: @escaping (INObjectCollection<StorySection>?, Error?) -> Void) {
        SDKInitializer.initializeArcXPSDKs()
        let viewModel = ContentViewModel()
        var categories = [StorySection]()
        viewModel.fetchSectionsForWidget { result in
            switch result {
            case .success(let sections):
                for section in sections {
                    let sectionDisplayName = section.name?.replacingOccurrences(of: "Mobile - ", with: "")
                    let category = StorySection(identifier: section.id, display: sectionDisplayName ?? "")
                    category.alias = section.name?.lowercased().replacingOccurrences(of: " ", with: "")
                    categories.append(category)
                }
                let collection = INObjectCollection(items: categories)
                completion(collection, nil)
            case .failure:
                break
            }

        }
    }

    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
