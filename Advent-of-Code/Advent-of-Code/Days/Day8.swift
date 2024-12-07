//
//  Day8.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/8/24.
//

import SwiftUI

// MARK: - View
struct Day8View: AdventDayView {
    @Bindable private var viewModel = Day8ViewModel()
    let dayNumber = 8
    
    var body: some View {
        VStack(spacing: 20) {
            exampleSection
            Divider()
            realDataSection
        }
        .padding()
    }
    
    var exampleSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Example").font(.title)
            Text("Example input: \(viewModel.part1(viewModel.example))")
            Text("Part 2").bold()
            Text("Example input: \(viewModel.part2(viewModel.example))")
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Example input: \(viewModel.part1(viewModel.real))")
            Text("Part 2:").bold()
            Text("Example input: \(viewModel.part2(viewModel.real))")
        }
    }
}

// MARK: - ViewModel
@Observable
final class Day8ViewModel {
    // MARK: - Properties
    private(set) var example = ""
    private(set) var real = ""
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
}

// MARK: - Private methods
private extension Day8ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day8", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
}

// MARK: - Public Methods
extension Day8ViewModel {
    func part1(_ input: String) -> Int {
        return 0
    }
    
    func part2(_ input: String) -> Int {
        return 0
    }
}

#Preview {
    Day8View()
}
