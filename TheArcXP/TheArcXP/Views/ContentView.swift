//
//  ContentView.swift
//  the-arcxp-iOS
//
//  Created by Soldier Williams on 2/10/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabBarView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
