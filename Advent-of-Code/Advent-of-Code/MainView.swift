//Content View

import SwiftUI

struct MainView: View {
    private var adventDays: [AdventDay]
    @State private var showDay = false
    @State private var selectedDay: AdventDay?

    init() {
        let currentDay = Calendar.current.component(.day, from: Date())
        adventDays = AdventDataSource.days.filter { $0.day <= currentDay }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                titleView
                
                List(adventDays) { day in
                    NavigationLink(destination:
                                    Group {
                        if let dayView = day.view {
                            dayView
                        } else {
                            Text("View not available for Day \(day.day)")
                        }
                    }
                    ) {
                        Text("Day \(day.day): \(day.title)")
                    }
                }
            }
        }
    }
    
    private var titleView: some View {
        HStack(spacing: 0) {
            ForEach(Array("Advent of Code".enumerated()), id: \.offset) { index, letter in
                Text(String(letter))
                    .foregroundColor(index % 2 == 0 ? .green : .red)
                    .fontDesign(.serif)
                    .font(.largeTitle)
                    .bold()
            }
        }
    }

}

#Preview {
    MainView()
}

