//
//  ErrorBannerModifier.swift
//  the-arcxp-iOS
//
//  Created by Soldier Williams on 3/3/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

enum BannerType {
    case warning
    case error
    case success

    var tintColor: Color {
        switch self {
        case .warning:
            return Color.yellow
        case .error:
            return Color.red
        case .success:
            return Color.green
        }
    }
}

struct ErrorBannerModifier: ViewModifier {
    
    @Binding var data: BannerData
    @Binding var show: Bool
    @Environment(\.colorScheme) var colorScheme
    
    struct BannerData {
        var title: String
        var detail: String
        var type: BannerType
    }
#if os(tvOS)
    func body(content: Content) -> some View {
        ZStack {
            content
            if showMenu {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(ThemeManager.errorBannerForegroundColor)
                    .padding(12)
                    .background(data.type.tintColor)
                    Spacer()
                }
                .padding()
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }
        }
    }
#else
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data.title)
                                .bold()
                            Text(data.detail)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data.type.tintColor)
                    Spacer()
                }
                .padding()
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        show = false
                    }
                }
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation {
                            show = false
                        }
                    }
                })
            }
        }
    }
#endif
}

extension View {
    func banner(data: Binding<ErrorBannerModifier.BannerData>, show: Binding<Bool>) -> some View {
        modifier(ErrorBannerModifier(data: data, show: show))
    }
}
