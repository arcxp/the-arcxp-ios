//
//  DateFormatterExtension.swift
//
//  Created by Amani Hunter on 7/12/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let widgetFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}
