//
//  Day1.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/1/24.
//

import SwiftUI

struct Day1View: AdventDayView {
    @Bindable var viewModel = Day1ViewModel()
    let dayNumber = 1

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
            
            Text("Similarity")
                .bold()
            Text("\(viewModel.exampleSimilarity)")
        }
    }
    
    private var realDataSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Real Data").font(.title)
            Text("Total Distance:")
                .bold()
            Text("\(viewModel.realDistance)")
            Text("Similarity")
                .bold()
            Text("\(viewModel.realSimilarity)")

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
    
    var exampleSimilarity: Int {
        findSimilarity(list1: example, list2: example2)
    }
    
    var realSimilarity: Int {
        findSimilarity(list1: leftArray, list2: rightArray)
    }

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
    
    private func findSimilarity(list1: [Int], list2: [Int]) -> Int {
        var similar = 0
        for i in list1 {
            similar += i * list2.count(where: {$0 == i})
        }
        return similar
    }
}

#Preview {
    Day1View()
}

