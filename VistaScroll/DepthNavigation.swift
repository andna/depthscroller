//
//  DepthNavigation.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 7/02/25.
//

import SwiftUI

struct DepthNavigation: View {
    
    @Binding var isFullMap: Bool
    @Binding var currentDepth: Double
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            
            VStack {
                VStack {
                    Toggle(
                        icon: "rectangle.expand.vertical",
                        help: "toggle full map",
                        isToggled: isFullMap,
                        action: {
                            withAnimation {
                                isFullMap.toggle()
                            }
                        }
                    )
                    
                }
                .padding()
                .glassBackgroundEffect()
                
                
                
            }
            .padding()
            
            Map(currentDepth: $currentDepth, isFullMap: isFullMap)
                .frame(height: isFullMap ? 700 : 150)
            
            Controls(currentDepth: $currentDepth)
                .opacity(isFullMap ? 0 : 1)
            
        }
        .rotation3DEffect(
            .degrees(isFullMap ? 0 : 42),
            axis: (x: 1.0, y: 0.0, z: 0.0),
            anchor: .center)
        .frame(width: 400)
        .offset(z: isFullMap ? 0 : 150)
        .offset(y: isFullMap ? 0 : -20)
    }
}

