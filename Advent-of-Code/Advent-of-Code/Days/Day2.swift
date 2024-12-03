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
            
            Text("Safe Reports:")
                .bold()
            Text("\(viewModel.safeExampleReportsCount)")
                .multilineTextAlignment(.center)
            
            Text("Part 2: The Dampening ")
                .bold()
            Text("\(viewModel.safe_ish_ExampleReportsCount)")
                .multilineTextAlignment(.center)
        }
    }
    
    var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data")
                .font(.title)
            Text("Total Safe Reports:")
                .bold()
            Text("\(viewModel.safeRealReportsCount)")
            
            Text("Part 2: The Dampening")
                .bold()
            Text("\(viewModel.safe_ish_RealReportsCount)")
                .multilineTextAlignment(.center)
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
    
    var safe_ish_ExampleReportsCount: Int {
        calculateSafeReportsCount(from: example, dampened: true)
    }
    
    var safeRealReportsCount: Int {
        calculateSafeReportsCount(from: allReports)
    }
    
    var safe_ish_RealReportsCount: Int {
        calculateSafeReportsCount(from: allReports, dampened: true)
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
    
    func calculateSafeReportsCount(from reports: [[Int]], dampened: Bool = false) -> Int {
        guard !reports.isEmpty else { return 0 }
        if !dampened {
            return reports.reduce(0) { $0 + (isReportSafe($1) ? 1 : 0) }
        } else {
            // for each report, see if by removing 1 value it would be safe
            return reports.reduce(0) { $0 + (isReportSafeIsh($1) ? 1 : 0) }
        }
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
    
    func isReportSafeIsh(_ report: [Int]) -> Bool {
        if isReportSafe(report) {
            return true
        }
        
        // Try removing one value at a time and check if it becomes safe
        for i in 0..<report.count {
            var tempReport = report
            tempReport.remove(at: i)
            if isReportSafe(tempReport) {
                return true
            }
        }
        return false
    }
}

#Preview {
    Day2View()
}
