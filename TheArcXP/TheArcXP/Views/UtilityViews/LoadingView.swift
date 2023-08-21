//
//  LoadingView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/22/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State var animate = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            ThemeManager.secondaryBackgroundColor.ignoresSafeArea(.all)
            GeometryReader { geometry in
                NavigationView {
                    VStack {
                        ContentLoadingIndicator(width: geometry.size.width * 0.2,
                                                height: geometry.size.height * 0.09,
                                                $animate)
                    }
                }
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
