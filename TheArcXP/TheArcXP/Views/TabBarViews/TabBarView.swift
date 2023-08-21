//
//  TabBarView.swift
//  TheArcXP
//
//  Created by Soldier Williams on 3/21/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct TabBarView: View {

    @State var tabSelection = 0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView(selection: $tabSelection) {
            HomeTabView(collectionType: .story, tabSelection: $tabSelection)
                .ignoresSafeArea(.container, edges: [.trailing, .leading])
                .tabItem {
                    Image(systemName: Constants.ImageName.house)
                    Text(Constants.TabBar.home)
                }.tag(0)
                .navigationBarHidden(true).navigationBarTitle("")
            
            HomeTabView(collectionType: .video, tabSelection: $tabSelection)
                .ignoresSafeArea(.container, edges: [.trailing, .leading])
                .tabItem {
                    Image(systemName: Constants.ImageName.video)
                    Text(Constants.TabBar.video)
                }.tag(1)
                .navigationBarHidden(true).navigationBarTitle("")
            
            AccountTabView()
                .ignoresSafeArea(.container, edges: [.trailing, .leading])
                .tabItem {
                    Image(systemName: Constants.ImageName.person)
                    Text(Constants.Account.account)
                }.tag(2)
                .navigationBarHidden(true).navigationBarTitle("")
        }
        .accentColor(ThemeManager.tabBarItemColor)
        .background(colorScheme == .dark ? ThemeManager.darkModeBackgroundColor : ThemeManager.lightModeBackgroundColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
