//
//  Utils.swift
//  TheArcXP
//
//  Created by Mahesh Venkateswarlu on 7/26/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import ArcXP

struct SDKUtils {
    
    static func getResizeImageUrl(imageContentElement: ContentElement?, isFullSize: Bool = true) -> String? {
        guard let imageElement = imageContentElement as? ImageContentElement else {
            return nil
        }
        
        if isFullSize,
           let fullSizeUrl = imageElement.additionalProperties?.fullSizeResizeUrl {
            return prefixOrgDomain(relativePath: fullSizeUrl)
        } else if !isFullSize,
                let thumbnailSizeUrl = imageElement.additionalProperties?.thumbnailResizeUrl {
            return prefixOrgDomain(relativePath: thumbnailSizeUrl)
        }
        return nil
    }
    
    private static func prefixOrgDomain(relativePath: String) -> String {
        return "https://" + Constants.Org.contentDomain + relativePath
    }
    
    static func formattedAuthorNamesText(_ authorNames: [String]?) -> String? {
        if let authorNames = authorNames {
            if !authorNames.isEmpty {
                let authors = authorNames.joined(separator: ", ")
                let authorString = "By \(authors)"
                return authorString
            }
        }
        return nil
    }
    
    /// Converts the given date String into a readable format.
    /// i/p -> 2022-04-07T08:00:00.000Z
    /// o/p -> April 7, 2022 at 8:00 AM EDT
    /// - Parameter dateString: date `String` that needs to formatted
    /// - Returns: Formatted date `String`. If formating fails, returns nil
    public static func formattedDateWithTimeZone(dateString: String?) -> String? {
        guard let dateString = dateString else {
            return nil
        }
        let formattedDate = convertDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                                              toFormat: "MMMM d, yyyy 'at' h:mm a ",
                                              dateString)
        if let formattedDate = formattedDate,
           let timeZone = TimeZone.current.abbreviation() {
            return formattedDate + timeZone
        }
        return nil
    }

    /// Converts the given date String into the formats as provided in the arguments
    /// - Parameters:
    ///   - fromFormat: `String` the format of the input dateString
    ///   - toFormat: `String` the expected format to get convert into
    ///   - dateString: `String` date that needs to be converted
    /// - Returns: `String` formatted dateString with respect to the given format, If formatting fails, returns nil.
    public static func convertDateFormat(fromFormat: String,
                                         toFormat: String,
                                         _ dateString: String?) -> String? {
        guard let dateString = dateString else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = fromFormat
        let formattedDate = formatter.date(from: dateString)
        formatter.dateFormat = toFormat
        if let formattedDate = formattedDate {
            return formatter.string(from: formattedDate)
        }
        return nil
    }
}
