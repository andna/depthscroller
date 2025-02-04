//
//  CustomSlider.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 11/01/25.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var value: Double // Current value
    var range: ClosedRange<Double> = 0...1 // Default range
    var numberOfSteps: Int? = nil // Optional number of steps. If nil, it's continuous.
    
    // Customization properties
    var trackHeight: CGFloat = 4
    var thumbSize: CGFloat = 20
    var trackColor: Color = Color.gray.opacity(0.3)
    var progressColor: Color = Color.blue
    var thumbColor: Color = Color.white
    var thumbShadow: Color = Color.black.opacity(0.2)
    
    // Step customization
    var stepColor: Color = Color.gray
    var stepSize: CGFloat = 8
    // var stepSpacing: CGFloat? = nil // Optional: Calculate automatically if nil
    
    var stepEnabled: Bool = false // Whether to snap to steps
    
    // State to track hover on macOS
    @State private var isHovered: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let sliderHeight = geometry.size.height
            let clampedValue = min(max(value, range.lowerBound), range.upperBound)
            let normalizedValue = (clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound)
            let thumbX = CGFloat(normalizedValue) * sliderWidth
            
            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(trackColor)
                    .frame(height: trackHeight)
                
                // Progress track
                Capsule()
                    .fill(progressColor)
                    .frame(width: thumbX, height: trackHeight)
                
                // Step Indicators
                if let steps = numberOfSteps, steps > 1 {
                    // Determine whether to show steps based on platform and hover state
                    let showSteps: Bool = {
                        #if os(macOS)
                        return isHovered
                        #else
                        return true // Always show steps on platforms without hover
                        #endif
                    }()
                    
                    if showSteps {
                        ForEach(0..<steps, id: \.self) { step in
                            let stepPosition = CGFloat(step) / CGFloat(steps - 1) * sliderWidth
                            // Use a Button for better accessibility and interaction
                            Button(action: {
                                // Calculate the corresponding value for the step
                                let stepValue = Double(step) / Double(steps - 1)
                                let newValue = range.lowerBound + stepValue * (range.upperBound - range.lowerBound)
                                withAnimation(.interactiveSpring()) {
                                    self.value = newValue
                                }
                            }) {
                                Circle()
                                    .fill(stepColor)
                                    .frame(width: stepSize, height: stepSize)
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default button styling
                            .position(x: stepPosition, y: sliderHeight / 2)
                            .onHover { hovering in
                                isHovered = hovering
                            }
                        }
                    }
                }
                
                // Thumb
                Circle()
                    .fill(thumbColor)
                    .frame(width: thumbSize, height: thumbSize)
                    //.shadow(color: thumbShadow, radius: 2, x: 0, y: 2)
                    .position(x: thumbX, y: sliderHeight / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let relativeX = gesture.location.x
                                let clampedX = min(max(relativeX, 0.0), sliderWidth)
                                var newNormalizedValue = Double(clampedX / sliderWidth)
                                
                                if stepEnabled, let steps = numberOfSteps, steps > 1 {
                                    // Snap to nearest step
                                    let stepValue = 1.0 / Double(steps - 1)
                                    newNormalizedValue = (round(newNormalizedValue / stepValue) * stepValue)
                                }
                                
                                let newValue = range.lowerBound + newNormalizedValue * (range.upperBound - range.lowerBound)
                                withAnimation(.interactiveSpring()) {
                                    self.value = newValue
                                }
                            }
                    )
                    .offset(z: 2)
                    .accessibilityElement()
                    .accessibility(label: Text("Custom Slider"))
                    .accessibility(value: Text("\(Int(clampedValue))"))
                    .accessibility(hint: Text("Adjusts the value between \(Int(range.lowerBound)) and \(Int(range.upperBound))"))
                    .accessibilityAdjustableAction { direction in
                        let step: Double
                        if let steps = numberOfSteps, steps > 1 {
                            step = (range.upperBound - range.lowerBound) / Double(steps - 1)
                        } else {
                            step = (range.upperBound - range.lowerBound) / 100
                        }
                        switch direction {
                        case .increment:
                            self.value = min(self.value + step, range.upperBound)
                        case .decrement:
                            self.value = max(self.value - step, range.lowerBound)
                        default:
                            break
                        }
                    }
            }
            // Handle hover state on macOS
            .background(
                // Transparent background to detect hover
                Color.clear
                    .onHover { hovering in
                        #if os(macOS)
                        self.isHovered = hovering
                        #endif
                    }
            )
        }
        .frame(height: max(thumbSize, trackHeight))
    }
}


struct CustomSliderView: View {
    @State private var sliderValue: Double = 50 // Initial value
    let sliderRange = 0.0...100.0
    let steps = 20
    
    var body: some View {
        VStack {
            
            
            // Custom Slider with Steps and Hover Functionality
            CustomSlider(
                value: $sliderValue,
                range: sliderRange,
                numberOfSteps: steps,
                trackHeight: 6,
                thumbSize: 28,
                trackColor: Color.clear,
                progressColor: Color.clear,
                thumbColor: Color.white,
                thumbShadow: Color.black.opacity(0.3),
                stepColor: Color.white.opacity(0.01),
                stepSize: 25,
                stepEnabled: true // Enables snapping to steps
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: 600) // Optional: Limit the width for better appearance
    }
}

struct CustomSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSliderView()
    }
}
