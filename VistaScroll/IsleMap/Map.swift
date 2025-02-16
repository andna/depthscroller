//
//  Map.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 12/01/25.
//

import SwiftUI

struct Map: View {
    
    @Binding var currentDepth: Double
    
    var isFullMap: Bool = false
    
    var circleRadius: CGFloat = 55
    
    @State private var currentIsleIndex : Int = 0
    @State private var currentIsleSliderValue : Double = 0
    @State private var internalChange: Bool = false

    var verticalPaddingHeight : CGFloat = 50;
    
    
    var body: some View {
        
            let lineHeight = circleRadius / 2

        
            VStack {
                
                ZStack {
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            if isFullMap {
                                Spacer().frame(height: verticalPaddingHeight)
                            }
                            VStack(spacing: -lineHeight) {
                                ForEach(0..<50) { index in
                                    PatternUnit(index: index, currentIsleIndex: $currentIsleIndex, currentIsleSliderValue: Binding(
                                        get: { currentIsleSliderValue },
                                        set: { newValue in
                                            internalChange = true
                                            currentIsleSliderValue = newValue
                                        }
                                    ), circleRadius: circleRadius)
                                        .id(index)
                                }
                            }
                            
                            // Spacer().frame(height: verticalPaddingHeight)
                        }
                        .fadingEdges()
                        .onChange(of: currentIsleIndex){
                            withAnimation {
                               scrollProxy.scrollTo(currentIsleIndex, anchor: .center)
                           }
                        }
                    }
                }
                .glassBackgroundEffect()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            }
            .onChange(of: currentDepth){
                
                if !internalChange {
                   withAnimation{
                       currentIsleIndex = Int(currentDepth / depthsPerIsle)
                       let isEven = (currentIsleIndex % 2 == 0)
                       let directionMultiplier = isEven ? 1.0 : -1.0

                       
                    
                       currentIsleSliderValue = (isEven ? 0.0 : depthsPerIsle) + directionMultiplier * (currentDepth.truncatingRemainder(dividingBy: depthsPerIsle))
                       
                   }
               }
            }

            .onChange(of: currentIsleSliderValue){
                if internalChange {
                       internalChange = false // Reset flag
                        withAnimation{
                            let currentIsle = Int(currentDepth / depthsPerIsle)
                            let isEven = (currentIsle % 2 == 0)
                            
                                let valueToCalculate = isEven ? currentIsleSliderValue : (depthsPerIsle - currentIsleSliderValue)
                                currentDepth = valueToCalculate + (Double(currentIsle) * depthsPerIsle)
                        
                        
                        }
               }
            }
    }
}



struct PatternUnit: View {
    let index: Int
    @Binding var currentIsleIndex: Int
    @Binding var currentIsleSliderValue: Double
    let circleRadius: CGFloat
      
    
    
    
    var body: some View {
        // Compute necessary variables
        let isEven = index.isMultiple(of: 2)
        let isFirst = index == 0
        let lineHeight = circleRadius / 2
        
        let circleDiameter = circleRadius * 2
        let circleOffset = circleRadius * 0.75
        
        HStack(spacing: 0) {
            if !isFirst {
                quarterCircle(startAngle: isEven ? 90 : 180,
                              endAngle: isEven ? 180 : 270,
                              offsetX: circleRadius,
                              offsetY: isEven ? -circleOffset : circleOffset,
                              lineHeight: lineHeight,
                              circleDiameter: circleDiameter)
            }
            
        
            Isle(currentIsleIndex: $currentIsleIndex, index: index, sliderValue: $currentIsleSliderValue)
                .frame(width: 220 + (isFirst ? circleRadius : 0), height: lineHeight)
               
            
            quarterCircle(startAngle: isEven ? 270 : 0,
                          endAngle: isEven ? 0 : 90,
                          offsetX: -circleRadius,
                          offsetY: isEven ? circleOffset : -circleOffset,
                          lineHeight: lineHeight,
                          circleDiameter: circleDiameter)
        }
        .onHover { over in
            print(over)
        }
        .foregroundColor(.black)
        .offset(x: isFirst ? lineHeight : 0)
        
    
        .overlay{
            Text("Isle \(isFirst ? "XX" : "\(DoubleLetters[index])")")
                .font(.title)
                .fontWeight(.ultraLight)
                .offset(x: -80, y: -35)
                .opacity(isEven ? 1 : 0)
        }
    }
    
    @ViewBuilder
    private func quarterCircle(startAngle: Double, endAngle: Double, offsetX: CGFloat, offsetY: CGFloat, lineHeight: CGFloat, circleDiameter: CGFloat) -> some View {
        QuarterCircle(startAngle: startAngle,
                      endAngle: endAngle,
                      lineWidth: lineHeight)
            .frame(width: circleDiameter, height: circleDiameter)
            .offset(x: offsetX, y: offsetY)
    }
}


struct QuarterCircle: Shape {
    var startAngle: Double
    var endAngle: Double
    var lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Compute center and radii
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius - lineWidth

        // Draw outer arc
        path.addArc(center: center, radius: outerRadius, startAngle: .degrees(startAngle), endAngle: .degrees(endAngle), clockwise: false)
        // Draw inner arc
        path.addArc(center: center, radius: innerRadius, startAngle: .degrees(endAngle), endAngle: .degrees(startAngle), clockwise: true)
        path.closeSubpath()

        return path
    }
}
struct FadingEdgesMask: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(0.9),
                        Color.black,
                        Color.black,
                        Color.black.opacity(0.9),
                        Color.black.opacity(0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

struct DoubleLetters {
    static let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    static subscript(index: Int) -> String {
        guard index >= 0 && index < letters.count else {
            return "Out of range"
        }
        let letter = letters[index]
        return "\(letter)\(letter)"
    }
}

extension View {
    func fadingEdges() -> some View {
        modifier(FadingEdgesMask())
    }
}

