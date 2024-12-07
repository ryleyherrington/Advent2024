//
//  Day6.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/6/24.
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
    private(set) var example = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""
    private(set) var real = ""
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
}

struct Point: Hashable {
    let x: Int
    let y: Int
}

enum Direction {
    case up, right, down, left
    
    func turnRight() -> Direction {
        switch self {
        case .up: return .right
        case .right: return .down
        case .down: return .left
        case .left: return .up
        }
    }
    
    func move(_ point: Point) -> Point {
        switch self {
        case .up: return Point(x: point.x, y: point.y - 1)
        case .right: return Point(x: point.x + 1, y: point.y)
        case .down: return Point(x: point.x, y: point.y + 1)
        case .left: return Point(x: point.x - 1, y: point.y)
        }
    }
}

// MARK: - Private methods
private extension Day6ViewModel {
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day6", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
    
    func findGuardPath(_ input: String) -> Int {
        let grid = input.split(separator: "\n").map { Array($0) }
        let height = grid.count
        let width = grid.first?.count ?? 0
        
        // Find starting position and direction
        let startPosition = grid.enumerated().flatMap { y, row in
            row.enumerated().compactMap { x, char in
                char == "^" ? Point(x: x, y: y) : nil
            }
        }.first
        
        guard let currentPos = startPosition else { return 0 }
        
        func isInBounds(_ point: Point) -> Bool {
            return point.y >= 0 && point.y < height &&
            point.x >= 0 && point.x < width
        }
        
        func hasObstacle(_ point: Point) -> Bool {
            guard isInBounds(point) else { return true }
            return grid[point.y][point.x] == "#"
        }
        
        func nextState(_ state: (Point, Direction, Set<Point>)) -> (Point, Direction, Set<Point>)? {
            let (pos, dir, visited) = state
            let nextPos = dir.move(pos)
            
            guard isInBounds(nextPos) else { return nil }
            
            if hasObstacle(nextPos) {
                return (pos, dir.turnRight(), visited)
            } else {
                var newVisited = visited
                newVisited.insert(nextPos)
                return (nextPos, dir, newVisited)
            }
        }
        
        var visited = Set<Point>([currentPos])
        var state: (Point, Direction, Set<Point>) = (currentPos, .up, visited)
        
        while let newState = nextState(state) {
            state = newState
            visited = state.2
        }
        
        return visited.count
    }
    
    func findLoopPositions(_ input: String) -> Int {
        let grid = input.split(separator: "\n").map { Array($0) }
        let height = grid.count
        let width = grid[0].count
        
        // Find starting position and calculate initial path
        let start = grid.enumerated()
            .flatMap { y, row in
                row.enumerated().compactMap { x, char in
                    char == "^" ? Point(x: x, y: y) : nil
                }
            }
            .first!
            
        // Calculate initial path first
        func calculateInitialPath() -> Set<Point> {
            var visited = Set<Point>()
            var pos = start
            var dir: Direction = .up
            
            while true {
                visited.insert(pos)
                let nextPos = dir.move(pos)
                
                if !isInBounds(nextPos) { break }
                
                if grid[nextPos.y][nextPos.x] == "#" {
                    dir = dir.turnRight()
                } else {
                    pos = nextPos
                }
            }
            return visited
        }
        
        func isInBounds(_ point: Point) -> Bool {
            point.y >= 0 && point.y < height && point.x >= 0 && point.x < width
        }
        
        let initialPath = calculateInitialPath()
        var result = 0
        
        // Check each position in the initial path
        for newPos in initialPath {
            if newPos == start || grid[newPos.y][newPos.x] == "#" {
                continue
            }
            
            var guardPos = start
            var guardDir: Direction = .up
            var visited = Set<String>()
            
            while true {
                let nextPos = guardDir.move(guardPos)
                
                if !isInBounds(nextPos) {
                    break
                }
                
                if grid[nextPos.y][nextPos.x] == "#" || nextPos == newPos {
                    let uuid = "\(guardPos.x),\(guardPos.y),\(guardDir)" // This is a fake uuid...
                    if visited.contains(uuid) {
                        result += 1
                        break
                    }
                    
                    visited.insert(uuid)
                    guardDir = guardDir.turnRight()
                } else {
                    guardPos = nextPos
                }
            }
        }
        
        return result
    }
}

// MARK: - Public Methods
extension Day6ViewModel {
    func part1(_ input: String) -> Int {
        return findGuardPath(input)
    }
    
    func part2(_ input: String) -> Int {
        return findLoopPositions(input)
    }
}

#Preview {
    Day6View()
}
