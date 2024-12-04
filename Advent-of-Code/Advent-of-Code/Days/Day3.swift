//
//  Day3.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/3/24.
//

import RegexBuilder
import SwiftUI

// MARK: - View
struct Day3View: AdventDayView {
    @Bindable private var viewModel = Day3ViewModel()
    let dayNumber = 3
    
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
private extension Day3View {
    var exampleSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Example").font(.title)
            Text(viewModel.example)
            Text("\(viewModel.exampleMulValue)").multilineTextAlignment(.center)
            Text("Part 2").bold()
            Text(viewModel.example2)
            Text("\(viewModel.exampleMulValue2)").multilineTextAlignment(.center)
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Total Mult value: ").bold()
            Text("\(viewModel.realMulValue)")
            Text("Part 2:").bold()
            Text("\(viewModel.realMulValue2)")
        }
    }
}

// MARK: - ViewModel
@Observable
final class Day3ViewModel {
    // MARK: - Properties
    private(set) var example = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    private(set) var example2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    private(set) var real = ""

    var exampleMulValue: Int { calculateMulValueFromString(example) }
    var exampleMulValue2: Int { calculateMultsDoDont(example2) }
    var realMulValue: Int { calculateMulValueFromString(real) }
    var realMulValue2: Int { calculateMultsDoDont(real) }
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
    
    // MARK: - Private Methods
    private func loadReports() {
        guard let path = Bundle.main.path(forResource: "day3", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        real = content
    }
        
    private func calculateMulValueFromString(_ content: String) -> Int {
        let regex = Regex {
            "mul"
            "("
            OneOrMore(.digit)
            ","
            OneOrMore(.digit)
            ")"
        }

        return content.matches(of: regex).reduce(0) { result, match in
            let values = match.output
                .trimmingPrefix("mul(")
                .trimmingCharacters(in: CharacterSet(charactersIn: ")"))
                .split(separator: ",")
            guard let x = Int(values[0]), let y = Int(values[1]) else { return result }
            return result + x * y
        }
    }
    
    private func calculateMultsDoDont(_ content: String) -> Int {
        let regex = Regex {
            ChoiceOf {
                "do()"
                "don't()"
                Regex {
                    "mul"
                    "("
                    OneOrMore(.digit)
                    ","
                    OneOrMore(.digit)
                    ")"
                }
            }
        }
        
        var shouldSum = true
        var sum = 0
        
        for match in content.matches(of: regex) {
            let instruction = String(match.0)
            
            switch instruction {
            case "do()":
                shouldSum = true
            case "don't()":
                shouldSum = false
            default:
                if shouldSum {
                    sum += addMult(instruction)
                }
            }
        }
        
        return sum
    }
    
    private func addMult(_ instruction: String) -> Int {
        let numbers = instruction
            .trimmingPrefix("mul(")
            .trimmingCharacters(in: CharacterSet(charactersIn: ")"))
            .split(separator: ",")
            .compactMap { Int($0) }
        
        guard numbers.count == 2 else { return 0 }
        return numbers[0] * numbers[1]
    }
}

#Preview {
    Day3View()
}
