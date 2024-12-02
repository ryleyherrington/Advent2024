//
//  ChristmasLightsView.swift
//  Advent-of-Code
//
//  Created by Ryley on 12/2/24.
//

import SwiftUI

struct ChristmasLightView: View {
    @State private var isGlowing = true
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .pink]
    let bulbWidth: CGFloat = 14
    let bulbHeight: CGFloat = 20
    let spacing: CGFloat = 22
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                // String line
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 10))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 10))
                }
                .stroke(Color.gray, lineWidth: 2)
                
                HStack(spacing: spacing) {
                    ForEach(0..<Int(geometry.size.width/(bulbWidth + spacing)), id: \.self) { index in
                        ZStack {
                            // Outer ellipse
                            Ellipse()
                                .fill(colors[index % colors.count])
                                .frame(width: bulbWidth, height: bulbHeight)
                                .shadow(color: colors[index % colors.count],
                                        radius: isGlowing ? 5 : 0)
                            
                            // Inner white glow
                            Ellipse()
                                .fill(.white.opacity(isGlowing ? 0.6 : 0))
                                .frame(width: bulbWidth/2, height: bulbHeight/2)
                                .blur(radius: 2)
                                .rotationEffect(Angle(degrees: Double.random(in: 0..<10)))
                        }
                        .animation(
                            Animation
                                .linear(duration: 1.0)
                                .repeatForever()
                                .delay(index % 2 == 0 ? 0 : 1),
                            value: isGlowing
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 20)
        .onAppear {
            isGlowing.toggle()
        }
    }
}


#Preview {
    AdventTabView()
}
