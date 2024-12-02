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
        AdventDay(day: 2, title: ""),
        AdventDay(day: 3, title: ""),
        AdventDay(day: 4, title: ""),
        AdventDay(day: 5, title: ""),
        AdventDay(day: 6, title: ""),
        AdventDay(day: 7, title: ""),
        AdventDay(day: 8, title: ""),
        AdventDay(day: 9, title: ""),
        AdventDay(day: 10, title: ""),
        AdventDay(day: 11, title: ""),
        AdventDay(day: 12, title: ""),
        AdventDay(day: 13, title: ""),
        AdventDay(day: 14, title: ""),
        AdventDay(day: 15, title: ""),
        AdventDay(day: 16, title: ""),
        AdventDay(day: 17, title: ""),
        AdventDay(day: 18, title: ""),
        AdventDay(day: 19, title: ""),
        AdventDay(day: 20, title: ""),
        AdventDay(day: 21, title: ""),
        AdventDay(day: 22, title: ""),
        AdventDay(day: 23, title: ""),
        AdventDay(day: 24, title: ""),
        AdventDay(day: 25, title: "")
    ]
}
