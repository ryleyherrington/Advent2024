//
//  Day4.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/4/24.
//

import SwiftUI

// MARK: - View
struct Day4View: AdventDayView {
    @Bindable private var viewModel = Day4ViewModel()
    let dayNumber = 4
    
    var body: some View {
        VStack(spacing: 20) {
            exampleSection
            Divider()
            realDataSection
        }
        .padding()
    }
}

// MARK: - View Components
private extension Day4View {
    var exampleSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Example").font(.title)
            VStack(spacing: 0) {
                ForEach(viewModel.example.indices, id: \.self) { row in
                    Text("\(viewModel.example[row].joined())")
                        .monospaced()
                }
            }
            Text("Found: \(viewModel.findXMAS(viewModel.example))")
            Text("Part 2").bold()
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Found: \(viewModel.findXMAS(viewModel.real))")

            Text("Part 2:").bold()
        }
    }
}

// MARK: - ViewModel
@Observable
final class Day4ViewModel {
    // MARK: - Properties
    private(set) var example: [[String]] = [
        ["M","M","M","S","X","X","M","A","S","M"],
        ["M","S","A","M","X","M","S","M","S","A"],
        ["A","M","X","S","X","M","A","A","M","M"],
        ["M","S","A","M","A","S","M","S","M","X"],
        ["X","M","A","S","A","M","X","A","M","M"],
        ["X","X","A","M","M","X","X","A","M","A"],
        ["S","M","S","M","S","A","S","X","S","S"],
        ["S","A","X","A","M","A","S","A","A","A"],
        ["M","A","M","M","M","X","M","M","M","M"],
        ["M","X","M","X","A","X","M","A","S","X"]
    ]
    private(set) var real = [[String]]()

    // MARK: - Initialization
    init() {
        loadReports()
    }
    
    // MARK: - Private Methods
    private func loadReports() {
        guard let path = Bundle.main.path(forResource: "day4", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        //TODO
        real = content.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .map { Array($0).map(String.init) }
    }
    
    func findXMAS(_ game: [[String]]) -> Int {
        let rows = game.count
        let cols = game[0].count
        
        // Direction vectors for all 8 possible directions
        let dirRows = [-1, -1, -1, 0, 0, 1, 1, 1]
        let dirCols = [-1, 0, 1, -1, 1, -1, 0, 1]
        
        func isValid(_ row: Int, _ col: Int) -> Bool {
            return row >= 0 && row < rows && col >= 0 && col < cols
        }
        
        func checkWord(_ row: Int, _ col: Int, _ direction: Int) -> Bool {
            let word = "XMAS"
            var currentRow = row
            var currentCol = col
            
            for char in word {
                if !isValid(currentRow, currentCol) ||
                   game[currentRow][currentCol] != String(char) {
                    return false
                }
                currentRow += dirRows[direction]
                currentCol += dirCols[direction]
            }
            return true
        }
        
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols {
                if game[row][col] == "X" {
                    // Check all 8 directions from this X
                    for dir in 0..<8 {
                        if checkWord(row, col, dir) {
                            count += 1
                        }
                    }
                }
            }
        }
        
        return count
    }
}

#Preview {
    Day4View()
}
