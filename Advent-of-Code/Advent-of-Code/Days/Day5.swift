//
//  Day4.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/5/24.
//

import SwiftUI

// MARK: - View
struct Day5View: AdventDayView {
    @Bindable private var viewModel = Day5ViewModel()
    let dayNumber = 5
    
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
final class Day5ViewModel {
    // MARK: - Properties
    private(set) var example = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """
    private(set) var real = ""
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
}

struct Rule {
    let x: Int
    let y: Int
}

// MARK: - Private methods
private extension Day5ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day5", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        
        real = content
    }
    
    func parseInput(_ input: String) -> (rules: [Rule], updates: [[Int]]) {
        let sections = input.components(separatedBy: "\n\n")
        guard sections.count == 2 else {
            return ([], [])
        }
        
        // Get Rules from string
        let rules = sections[0].components(separatedBy: .newlines)
            .compactMap { line -> Rule? in
                let parts = line.split(separator: "|")
                guard parts.count == 2,
                      let x = Int(parts[0]),
                      let y = Int(parts[1]) else {
                    return nil
                }
                return Rule(x: x, y: y)
            }
        
        // Get updates from second section, each line = new update
        let updates = sections[1].components(separatedBy: .newlines)
            .compactMap { line -> [Int]? in
                guard !line.isEmpty else { return nil }
                return line.split(separator: ",")
                    .compactMap { Int($0) }
            }
        
        return (rules, updates)
    }
    
    func isUpdateValid(_ update: [Int], rules: [Rule]) -> Bool {
        for rule in rules {
            // Check if both numbers from the rule exist in the update
            if update.contains(rule.x) && update.contains(rule.y) {
                guard let posX = update.firstIndex(of: rule.x),
                      let posY = update.firstIndex(of: rule.y) else {
                    continue
                }
                // If Y comes before X, ya burnt
                if posY < posX {
                    return false
                }
            }
        }
        return true
    }
    
    func findMiddleNumbers(_ input: String) -> Int {
        let (rules, updates) = parseInput(input)
        
        let validUpdates = updates.filter { isUpdateValid($0, rules: rules) }
        let middleNumbers = validUpdates.map { update in
            update[update.count / 2]
        }
        
        return middleNumbers.reduce(0, +)
    }
}

// MARK: - Public Methods
extension Day5ViewModel {
    func part1(_ input: String) -> Int {
        return findMiddleNumbers(input)
    }
    
    func part2(_ input: String) -> Int {
        let (rules, updates) = parseInput(input)
        let invalidUpdates = updates.filter { !isUpdateValid($0, rules: rules) }
        
        func createGraph(for update: [Int]) -> [Int: Set<Int>] {
            var graph: [Int: Set<Int>] = [:]
            update.forEach { graph[$0] = Set<Int>() } // Make empty set
            
            // Add edges based on rules that apply to this update
            for rule in rules {
                if update.contains(rule.x) && update.contains(rule.y) {
                    graph[rule.x, default: Set()].insert(rule.y)
                }
            }
            return graph
        }
        
        func topologicalSort(_ update: [Int]) -> [Int] {
            let graph = createGraph(for: update)
            var visited = Set<Int>()
            var sorted: [Int] = []
            
            func visit(_ node: Int) {
                if visited.contains(node) { return }
                visited.insert(node)
                
                for next in graph[node, default: Set()] {
                    visit(next)
                }
                
                sorted.insert(node, at: 0)
            }
            
            let nodes = Set(update)
            nodes.forEach { visit($0) }
            
            return sorted
        }
        
        // Sort each invalid update and get middle numbers
        let middleNumbers = invalidUpdates.map { update -> Int in
            let sortedUpdate = topologicalSort(update)
            return sortedUpdate[sortedUpdate.count / 2]
        }
        
        return middleNumbers.reduce(0, +)
    }
}

#Preview {
    Day5View()
}
