//
//  Day1.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/1/24.
//

import SwiftUI

struct Day1View: AdventDayView {
    let dayNumber = 1
    @Bindable var viewModel = Day1ViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            exampleSection
            Divider()
            realDataSection
        }
        .padding()
        .onAppear { viewModel.calculateDistances() }
    }
    
    private var exampleSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Example").font(.title)
            
            Text("Sorted Lists:")
                .bold()
            Text("\(viewModel.example)\n\(viewModel.example2)")
                .multilineTextAlignment(.center)
            
            Text("Individual Distances:")
                .bold()
            Text("\(viewModel.exampleDistances)")
                .multilineTextAlignment(.center)
            
            Text("Total Distance:")
                .bold()
            Text("\(viewModel.totalExample)")
        }
    }
    
    private var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Total Distance:")
                .bold()
            Text("\(viewModel.realDistance)")
        }
    }
}

@Observable
final class Day1ViewModel {
    // MARK: - Properties
    private(set) var example = [3, 4, 2, 1, 3, 3].sorted()
    private(set) var example2 = [4, 3, 5, 3, 9, 3].sorted()
    private(set) var totalExample = 0
    private(set) var exampleDistances: [Int] = []
    private(set) var realDistance = 0
    
    private var leftArray: [Int] = []
    private var rightArray: [Int] = []
    
    // MARK: - Initialization
    init() {
        loadData()
    }
    
    // MARK: - Public Methods
    func calculateDistances() {
        exampleDistances = calculateDistances(list1: example, list2: example2)
        totalExample = exampleDistances.reduce(0, +)
        realDistance = calculateDistances(list1: leftArray, list2: rightArray).reduce(0, +)
    }
    
    // MARK: - Private Methods
    private func loadData() {
        if let (left, right) = loadNumberArrays(from: "day1") {
            leftArray = left.sorted()
            rightArray = right.sorted()
        }
    }
    
    private func calculateDistances(list1: [Int], list2: [Int]) -> [Int] {
        zip(list1, list2).map { abs($0 - $1) }
    }
    
    private func loadNumberArrays(from filename: String) -> (left: [Int], right: [Int])? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }
        
        let allNumbers = content.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .compactMap { Int($0) }
        
        let leftArray = stride(from: 0, to: allNumbers.count, by: 2).map { allNumbers[$0] }
        let rightArray = stride(from: 1, to: allNumbers.count, by: 2).map { allNumbers[$0] }
        
        return (leftArray, rightArray)
    }
}

#Preview {
    Day1View()
}

