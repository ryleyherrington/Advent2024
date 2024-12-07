//
//  Day7.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/7/24.
//

import SwiftUI

// MARK: - View
struct Day7View: AdventDayView {
    @Bindable private var viewModel = Day7ViewModel()
    let dayNumber = 7
    
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
final class Day7ViewModel {
    // MARK: - Properties
    private(set) var example = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""
    private(set) var real = ""
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
}

// MARK: - Private methods
private extension Day7ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day7", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
    
    func parseExpressions(input: String) -> [(Int, [Int])] {
        return input.components(separatedBy: .newlines).compactMap { line in
            let parts = line.components(separatedBy: ": ")
            guard parts.count == 2, let target = Int(parts[0]) else { return nil }
            let numbers = parts[1].components(separatedBy: .whitespaces).compactMap { Int($0) }
            
            return (target, numbers)
        }
    }
    
    func findExpressions(numbers: [Int], target: Int, part2: Bool = false) -> Int {
        func concatenate(_ a: Int, _ b: Int) -> Int {
            return Int("\(a)\(b)")!
        }
        
        func evaluate(_ nums: [Int], _ ops: [String]) -> Int {
            var result = nums[0]
            for i in 0..<ops.count {
                if ops[i] == "+" {
                    result += nums[i + 1]
                } else if ops[i] == "*" {
                    result *= nums[i + 1]
                } else if part2 && ops[i] == "||" {
                    result = concatenate(result, nums[i + 1])
                }
            }
            return result
        }
        
        func generateCombinations(_ currentOps: [String], _ position: Int) -> Bool {
            if position == numbers.count - 1 {
                return evaluate(numbers, currentOps) == target
            }
            
            var found = false
            found = found || generateCombinations(currentOps + ["+"], position + 1)
            found = found || generateCombinations(currentOps + ["*"], position + 1)
            
            if part2 {
                found = found || generateCombinations(currentOps + ["||"], position + 1)
            }
            
            return found
        }
        
        return generateCombinations([], 0) ? target : 0
    }
}

// MARK: - Public Methods
extension Day7ViewModel {
    func part1(_ input: String) -> Int {
        let expressions = parseExpressions(input: input)
        return expressions.reduce(0) { sum, expr in
            sum + findExpressions(numbers: expr.1, target: expr.0)
        }
    }
    
    func part2(_ input: String) -> Int {
        let expressions = parseExpressions(input: input)
        return expressions.reduce(0) { sum, expr in
            sum + findExpressions(numbers: expr.1, target: expr.0, part2: true)
        }
    }
}

#Preview {
    Day7View()
}
