//
//  Controls.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 13/01/25.
//

import SwiftUI

struct Controls: View {
    @Binding var currentDepth: Double
    
    @State private var isIncreasing: Bool = false
    @State private var isDecreasing: Bool = false
    @State private var timer: Timer? = nil
    @State private var holdDuration: Double = 0.0
    @State private var speedLevel: Int = 0
    
    private func startTimer(increase: Bool) {
        stopTimer() // Reset any active timers
        holdDuration = 0.0 // Reset hold duration
        updateDepthAndState(increase: increase)
        speedLevel = 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.holdDuration += 0.1
            let increment = self.calculateIncrement(holdDuration: self.holdDuration)
            
            if self.currentDepth > 0 || increase {
                self.updateDepthAndState(increase: increase, increment: increment)
            }
        }
    }

    private func updateDepthAndState(increase: Bool, increment: Double = 1.0) {
        withAnimation {
            self.currentDepth += (increase ? increment : -increment)
            isIncreasing = increase
            isDecreasing = !increase
        }
    }

    private func setLevel(_ newLevel: Int) {
        withAnimation{
            speedLevel = newLevel
        }
    }
    
    private func calculateIncrement(holdDuration: Double) -> Double {
        if holdDuration >= 3.0 {
            setLevel(3)
            return 0.8
        } else if holdDuration >= 1.5 {
            setLevel(2)
            return 0.4
        } else {
            setLevel(1)
            return 0.15
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        holdDuration = 0.0
        setLevel(0)
        withAnimation {
            isIncreasing = false
            isDecreasing = false
        }
    }
    
    var body: some View {
        
        
        VStack {
            VStack {
                Toggle(
                    icon: "chevron.up",
                    help: "expand",
                    isToggled: isIncreasing,
                    onPressGesture: { pressing in
                        if pressing {
                            startTimer(increase: true)
                        } else {
                            stopTimer()
                        }
                    },
                    level: isIncreasing ? speedLevel : 1
                )
                
                
                Toggle(
                    icon: "chevron.down",
                    help: "collapse",
                    isToggled: isDecreasing,
                    onPressGesture: { pressing in
                        if pressing {
                            startTimer(increase: false)
                        } else {
                            stopTimer()
                        }
                    },
                    level: isDecreasing ? speedLevel : 1
                )
        
            
               
            }
            .padding()
            .glassBackgroundEffect()
            
            
        
        }
        .padding()
        .overlay{
            
            if speedLevel > 0 && speedLevel < 3 {
                Text("Hold to\naccelerate")
                    .font(.footnote)
                    .fontWeight(.light)
                    .kerning(-0.5)
                    .lineSpacing(2)
                    .offset(x: 75, y: isIncreasing ? -25 : 30)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        
    }
}


struct Toggle: View {
    var icon: String
    var help: String
    var isToggled: Bool
    var action: (() -> Void)?
    var onPressGesture: ((Bool) -> Void)?
    var level: Int = 1

    var body: some View {
        VStack(spacing: -20){
            ForEach(0..<level, id: \.self) { _ in
                Image(systemName: icon)
                    .offset(y: level == 3 ? 5 : 0)
            }
        }
        .padding(8)
        .frame(width: buttonSize, height: buttonSize)
        .background(isToggled ? .white : .black.opacity(0.01))
        .foregroundColor(isToggled ? .black : .white)
        .buttonBorderShape(.circle)
        .clipShape(Circle())
        .contentShape(.hoverEffect, Circle())
        .hoverEffect()
        //.help(help)
        .onTapGesture {
            action?()
        }
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            onPressGesture?(pressing)
        }, perform: {})
        .offset(z: onPressGesture == nil ? 0 : (isToggled ? 0 : 10))
    }
}


/*

#Preview {
    Controls()
}

*/
