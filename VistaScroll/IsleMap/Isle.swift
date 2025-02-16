//
//  Isle.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 11/01/25.
//

import SwiftUI

struct Isle: View {

    @Binding var currentIsleIndex : Int
    var index: Int = 0
    @Binding var sliderValue : Double
    
    var body: some View {
        
        let sliderRange = 1.0...depthsPerIsle
        let showSlider = currentIsleIndex == index
        ZStack{
            if index == 0 {
                Rectangle()
                    .cornerRadius(1500, corners: [.topLeft, .bottomLeft])
            } else {
                Rectangle()
            }
        
        
            if showSlider {
                CustomSlider(
                    value: $sliderValue,
                    range: sliderRange,
                    numberOfSteps: 1,
                    trackHeight: 6,
                    thumbSize: 28,
                    trackColor: .clear,
                    progressColor: .clear,
                    thumbColor: showSlider ? .white : .clear,
                    thumbShadow: .black.opacity(0.3),
                    stepColor: .red.opacity(0.01),
                    stepSize: 15,
                    stepEnabled: true // Enables snapping to steps
                ).onChange(of: sliderValue){
                    currentIsleIndex = index
                }
            }
           
        }
    }
}



// Extension to support rounding specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// Use the same RoundedCorner as above
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
