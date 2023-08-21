//
//  ContentLoadingIndicator.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct ContentLoadingIndicator: View {
    let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round)
    let mainColor = ThemeManager.loadingIndicatorColor
    let secondaryColor = ThemeManager.loadingIndicatorColor.opacity(0.5)
    var indicatorFrameHeight: Double
    var indicatorFrameWidth: Double
    @Binding var animate: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor
            Circle()
                .trim(from: 0, to: 0.6)
                .stroke(
                    AngularGradient(gradient: .init(colors: [mainColor, secondaryColor]), center: .center),
                    style: strokeStyle)
                .frame(maxWidth: indicatorFrameWidth, maxHeight: indicatorFrameHeight)
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
        }.onAppear {
            animate.toggle()
        }
    }
    
    init (width: Double, height: Double, _ animate: Binding<Bool>) {
        indicatorFrameWidth = width
        indicatorFrameHeight = height
        _animate = animate
    }
}
