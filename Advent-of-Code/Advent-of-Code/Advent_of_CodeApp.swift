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
                PuzzleView()
                    .tabItem {
                        Label("Info", systemImage: "calendar")
                    }
            }
        }
    }
}

#Preview {
    AdventTabView()
}
