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
            Text("Found: \(viewModel.findCrossMas(viewModel.example))")
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Found: \(viewModel.findXMAS(viewModel.real))")
            Text("Part 2:").bold()
            Text("Found: \(viewModel.findCrossMas(viewModel.real))")
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
}

// MARK: - File Loading
private extension Day4ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day4", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = parseGameBoard(content)
    }
    
    func parseGameBoard(_ input: String) -> [[String]] {
        input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { Array($0).map(String.init) }
    }
}

// MARK: - XMAS Search
private extension Day4ViewModel {
    struct GridPosition {
        let row: Int
        let col: Int
    }
    
    struct Direction {
        static let rows = [-1, -1, -1, 0, 0, 1, 1, 1]
        static let cols = [-1, 0, 1, -1, 1, -1, 0, 1]
    }
    
    func isValid(_ pos: GridPosition, rows: Int, cols: Int) -> Bool {
        pos.row >= 0 && pos.row < rows && pos.col >= 0 && pos.col < cols
    }
}

// MARK: - Public Methods
extension Day4ViewModel {
    func findXMAS(_ game: [[String]]) -> Int {
        let rows = game.count
        let cols = game[0].count
        
        func checkWord(_ start: GridPosition, _ direction: Int) -> Bool {
            var current = start
            return "XMAS".allSatisfy { char in
                guard isValid(current, rows: rows, cols: cols),
                      game[current.row][current.col] == String(char) else {
                    return false
                }
                current = GridPosition(
                    row: current.row + Direction.rows[direction],
                    col: current.col + Direction.cols[direction]
                )
                return true
            }
        }
        
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols where game[row][col] == "X" {
                count += (0..<8).filter { checkWord(GridPosition(row: row, col: col), $0) }.count
            }
        }
        return count
    }
    
    func findCrossMas(_ game: [[String]]) -> Int {
        let rows = game.count
        let cols = game[0].count
        
        func checkDiagonals(_ pos: GridPosition) -> Bool {
            let corners = [
                game[pos.row-1][pos.col-1],
                game[pos.row-1][pos.col+1],
                game[pos.row+1][pos.col-1],
                game[pos.row+1][pos.col+1]
            ]
            
            let isValidCorner = corners.allSatisfy { $0 == "M" || $0 == "S" }
            guard isValidCorner else { return false }
            
            let (tl, tr, bl, br) = (corners[0], corners[1], corners[2], corners[3])
            return ((tl == "M" && br == "S") || (tl == "S" && br == "M")) &&
                   ((tr == "M" && bl == "S") || (tr == "S" && bl == "M"))
        }
        
        var count = 0
        for row in 1..<(rows-1) {
            for col in 1..<(cols-1) where game[row][col] == "A" {
                if checkDiagonals(GridPosition(row: row, col: col)) {
                    count += 1
                }
            }
        }
        return count
    }
}

#Preview {
    Day4View()
}
