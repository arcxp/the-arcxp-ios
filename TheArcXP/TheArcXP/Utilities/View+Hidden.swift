//
//  View+Hidden.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Binding<Bool>) -> some View {
        opacity(shouldHide.wrappedValue ? 0 : 1)
    }
}
