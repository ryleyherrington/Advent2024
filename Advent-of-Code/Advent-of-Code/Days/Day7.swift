//
//  Day6View.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/6/24.
//


//
//  Day6View.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/6/24.
//


//
//  Day4.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/5/24.
//

import SwiftUI

// MARK: - View
struct Day6View: AdventDayView {
    @Bindable private var viewModel = Day6ViewModel()
    let dayNumber = 6
    
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
final class Day6ViewModel {
    // MARK: - Properties
    private(set) var example = ""
    private(set) var real = ""
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
}

// MARK: - Private methods
private extension Day6ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "Day6", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
}

// MARK: - Public Methods
extension Day6ViewModel {
    func part1(_ input: String) -> Int {
        return 0
    }
    
    func part2(_ input: String) -> Int {
        return 0
    }
}

#Preview {
    Day6View()
}
