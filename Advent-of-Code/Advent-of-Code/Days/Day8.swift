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

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    
    var description: String {
        return "(\(x), \(y))"
    }
    
    func offset(_ other: Point) -> Offset {
        return Offset(dx: other.x - x, dy: other.y - y)
    }
    
    func add(_ offset: Offset) -> Point {
        return Point(x: x + offset.dx, y: y + offset.dy)
    }
}

struct Offset {
    let dx: Int
    let dy: Int
}

struct Antenna: Hashable {
    let position: Point
    let frequency: Character
    
    func antinode(_ other: Antenna) -> Point? {
        guard frequency == other.frequency, self != other else {
            return nil
        }
        
        let offset = position.offset(other.position)
        return other.position.add(offset)
    }
    
    func antinodes(_ other: Antenna, checker: (Point) -> Bool) -> [Point]? {
        guard frequency == other.frequency, self != other else {
            return nil
        }
        
        let offset = position.offset(other.position)
        var antinodes: [Point] = [other.position]
        var antinode = other.position.add(offset)
        
        while checker(antinode) {
            antinodes.append(antinode)
            antinode = antinode.add(offset)
        }
        
        return antinodes
    }
}

// MARK: - ViewModel
@Observable
final class Day8ViewModel {
    private(set) var example = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""
    private(set) var real = ""
    private var antennas: [Antenna] = []
    private var boundaries: (width: Int, height: Int) = (0, 0)
    
    // MARK: - Initialization
    init() {
        self.loadReports()
    }
    
    // MARK: - Private methods
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day8", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
    
    func parseInput(_ input: String) -> [Antenna] {
        let rows = input.components(separatedBy: .newlines)
        var antennas: [Antenna] = []
        
        for (y, row) in rows.enumerated() {
            for (x, char) in row.enumerated() {
                guard char != "." else { continue }
                antennas.append(Antenna(position: Point(x: x, y: y), frequency: char))
            }
        }
        
        boundaries = (rows[0].count, rows.count)
        return antennas
    }
    
    func boundsChecker() -> (Point) -> Bool {
        return { point in
            point.x >= 0 && point.x < self.boundaries.width &&
            point.y >= 0 && point.y < self.boundaries.height
        }
    }
}

// MARK: - Public Methods
extension Day8ViewModel {
    func part1(_ input: String) -> Int {
        let antennas = parseInput(input)
        let boundsChecker = boundsChecker()
        
        return Set(
            antennas.flatMap { source in
                antennas.compactMap { target in
                    source.antinode(target)
                }
            }
            .filter(boundsChecker)
        ).count
    }
    
    func part2(_ input: String) -> Int {
        return 0
    }
}

#Preview {
    Day8View()
}
