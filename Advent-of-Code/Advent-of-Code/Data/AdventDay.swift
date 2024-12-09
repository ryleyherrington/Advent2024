//
//  AdventDay.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/1/24.
//

import SwiftUI

protocol AdventDayView: View {
    var dayNumber: Int { get }
}

struct AdventDay: Identifiable {
    let id = UUID()
    let day: Int
    var title: String
    var view: AnyView?
}

//Descriptions from https://adventofcode.com/2024/day/1 -- replace 1 with day of the month
struct AdventDataSource {
    static let days: [AdventDay] = [
        AdventDay(day: 1, title: "Historian Hysteria", view: AnyView(Day1View())),
        AdventDay(day: 2, title: "Red-Nosed Reports",  view: AnyView(Day2View())),
        AdventDay(day: 3, title: "Mull It Over", view: AnyView(Day3View())),
        AdventDay(day: 4, title: "Ceres Search", view: AnyView(Day4View())),
        AdventDay(day: 5, title: "Print Queue", view: AnyView(Day5View())),
        AdventDay(day: 6, title: "Guard Gallivant", view: AnyView(Day6View())),
        AdventDay(day: 7, title: "Bridge Repair", view: AnyView(Day7View())),
        AdventDay(day: 8, title: "Resonant Collinearity", view: AnyView(Day8View())),
    ]
}
