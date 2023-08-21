//
//  ContentMetadata.swift
//  TheArcXP
//
//  Created by Amani Hunter on 6/5/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import Foundation
import ArcXP

struct ContentMetadata {
    var keywords: [String]
    var articleURL: String
    
    mutating func updateArticleMetadata(content: ArcXPContent) {
        // set metadata
        let headline = content.headlines?.basic ?? ""
        let subHeadline = content.subheadlines?.basic ?? ""
        let editorNote = content.editorNote ?? ""
        let location = content.location ?? ""
        let subtype = content.subtype ?? ""
        let channels = content.channels ?? [""]
        
        keywords.append(contentsOf: [headline, subHeadline, editorNote, location, subtype])
        keywords += channels
        articleURL = content.websiteUrl ?? ""
    }
}
