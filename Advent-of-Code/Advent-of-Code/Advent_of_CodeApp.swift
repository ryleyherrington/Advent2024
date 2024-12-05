//
//  Advent_of_CodeApp.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/1/24.
//

import SwiftUI

@main
struct Advent_of_CodeApp: App {
    var body: some Scene {
        WindowGroup {
            AdventTabView()
        }
    }
}

struct AdventTabView: View {
    var body: some View {
        ZStack {
            TabView {
                MainView()
                    .tabItem {
                        Label("Days", systemImage: "list.dash")
                    }
                TodayWebView()
                    .tabItem {
                        Label("Info", systemImage: "calendar")
                    }
            }
            .tint(.green)

            VStack {
                Spacer()
                ChristmasLightView()
                    .offset(y: -44)
            }
        }
    }
}

#Preview {
    AdventTabView()
}
