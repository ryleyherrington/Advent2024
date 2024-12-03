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
    let dayNumber = 2
    
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
            Text("Example")
                .font(.title)
            
            Text(viewModel.example)
            
            VStack(spacing: 4) {
                Text("\(viewModel.exampleMulValue)")
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data")
                .font(.title)
            VStack(spacing: 4) {
                Text("Total Mult value: ")
                    .bold()
                Text("\(viewModel.realMulValue)")
            }
        }
    }
}

// MARK: - ViewModel
@Observable
final class Day3ViewModel {
    // MARK: - Properties
    private(set) var example = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))" //161
    private(set) var real = ""

    var exampleMulValue: Int {
        calculateMulValueFromString(example)
    }
    
    var realMulValue: Int {
        calculateMulValueFromString(real)
    }
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
    
    // MARK: - Private Methods
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day3", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        
        real = content
    }
        
    func calculateMulValueFromString(_ content: String, isReal: Bool = false) -> Int {
        let regex = Regex {
            "mul"
            "("
            OneOrMore(.digit)
            ","
            OneOrMore(.digit)
            ")"
        }

        // Find matches of mul(x,y) in the larger string
        let matches = content.matches(of: regex).map { String($0.0) }
        
        // need to multiple all the x,y values, and then add up all of the results
        return matches.reduce(0) { result, match in
            let values = match
                .trimmingPrefix("mul(")
                .trimmingCharacters(in: CharacterSet(charactersIn:")"))
                .split(separator: ",")
            if let x = Int(values[0]), let y = Int(values[1]) {
                return result + x * y
            }
            return result
        }
    }
}

#Preview {
    Day3View()
}
