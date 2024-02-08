//
//  CustomNavLinkView.swift
//  TheArcXP
//
//  Created by Amani Hunter on 11/14/23.
//  Copyright © 2023 Arc XP. All rights reserved.
//

import SwiftUI

struct CustomNavLinkView<Destination: View, Label: View>: View {
    let destination: Destination
    let label: () -> Label
    
    init(destination: Destination, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            label()
        }
    }
}
