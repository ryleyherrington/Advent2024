//
//  Day2.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/2/24.
//

import SwiftUI

// MARK: - View
struct Day2View: AdventDayView {
    @Bindable private var viewModel = Day2ViewModel()
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
private extension Day2View {
    var exampleSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Example")
                .font(.title)
            
            ForEach(Array(zip(viewModel.exampleAnswer, viewModel.example).enumerated()),
                   id: \.offset) { _, pair in
                Text("\(pair.0) \(pair.1)")
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 4) {
                Text("Safe Reports:")
                    .bold()
                Text("\(viewModel.safeExampleReportsCount)")
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data")
                .font(.title)
            VStack(spacing: 4) {
                Text("Total Safe Reports:")
                    .bold()
                Text("\(viewModel.safeRealReportsCount)")
            }
        }
    }
}

// MARK: - ViewModel
@Observable
final class Day2ViewModel {
    // MARK: - Types
    private enum Constants {
        static let maxDifference = 3
        static let minDifference = 1
    }
    
    // MARK: - Properties
    private(set) var example: [[Int]] = [
        [7, 6, 4, 2, 1],
        [1, 2, 7, 8, 9],
        [9, 7, 6, 2, 1],
        [1, 3, 2, 4, 5],
        [8, 6, 4, 4, 1],
        [1, 3, 6, 7, 9]
    ]
    
    //Only for UI to look a little better... 😅
    private(set) var exampleAnswer = ["✅", "❌", "❌", "❌", "❌", "✅"]
    private(set) var allReports: [[Int]] = []
    
    var safeExampleReportsCount: Int {
        calculateSafeReportsCount(from: example)
    }
    
    var safeRealReportsCount: Int {
        calculateSafeReportsCount(from: allReports)
    }
    
    // MARK: - Initialization
    init() {
        loadReports()
    }
    
    // MARK: - Private Methods
    func loadReports() {
        guard let path = Bundle.main.path(forResource: "day2", ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }
        
        allReports = content.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { line in
                line.split(separator: " ")
                    .compactMap { Int($0) }
            }
    }
    
    func calculateSafeReportsCount(from reports: [[Int]]) -> Int {
        guard !reports.isEmpty else { return 0 }
        return reports.reduce(0) { $0 + (isReportSafe($1) ? 1 : 0) }
    }
    
    func isReportSafe(_ report: [Int]) -> Bool {
        let isMonotonic = report == report.sorted(by: <) || report == report.sorted(by: >)
        guard isMonotonic else { return false }
        
        return zip(report, report.dropFirst()).allSatisfy { prev, current in
            let difference = abs(prev - current)
            return difference >= Constants.minDifference &&
                   difference <= Constants.maxDifference
        }
    }
}

#Preview {
    Day2View()
}
