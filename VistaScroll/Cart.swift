//
//  Cart.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 7/02/25.
//

import SwiftUI
import RealityKit



struct Cart: View {
    
    var cartItemsAmount: Int = 0
    
    var width: CGFloat = 300
    let height: CGFloat = 70
    let depth: CGFloat = 80
    
    let showDevColors = false
    let nonDevColor = Color.black.opacity(0.4)
    
    var body: some View {
       
        ZStack{
            ZStack {
                // Bottom Face
                Rectangle()
                    .fill(showDevColors ? .gray : nonDevColor)
                    .frame(width: width, height: depth)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                    .rotation3DEffect(
                        Angle(degrees: 90),
                        axis: (x: 1, y: 0, z: 0)
                    )
                    .offset(y: height/2)
            
                // Front Face
                Rectangle()
                    .fill(showDevColors ? .blue : nonDevColor)
                    .frame(width: width, height: height)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                    .offset(z: depth/2)
                
                // Back Face
                Rectangle()
                    .fill(showDevColors ? .red : nonDevColor)
                    .frame(width: width, height: height)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                    .offset(z: -depth/2)
                
                // Right Face
                Rectangle()
                    .fill(showDevColors ? .green : nonDevColor)
                    .frame(width: depth, height: height)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                    .rotation3DEffect(
                        Angle(degrees: -90),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .offset(x: width/2)
                
                // Left Face
                Rectangle()
                    .fill(showDevColors ? .yellow : nonDevColor)
                    .frame(width: depth, height: height)
                    .overlay(Rectangle().stroke(Color.black, lineWidth: 1))
                
                    .rotation3DEffect(
                        Angle(degrees: -90),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .offset(x: -width/2)
                
              
            }
            .frame(width: 300, height: 300)
            
            var computedSpacing: CGFloat {
                // For 2 items: spacing = -50, for 7 items: spacing = -100.
                let minSpacing: CGFloat = -20
                let maxSpacing: CGFloat = -60 //when 7
                // Clamp the value between 2 and 7 to avoid negative interpolation issues.
                let count = CGFloat(max(2, min(cartItemsAmount, 7)))
                return minSpacing + (maxSpacing - minSpacing) * ((count - 2) / (7 - 2))
            }
            
            var computedXOffset: CGFloat {
                // For 7 items: x offset = 50, for 2 items: x offset = 100.
                let minOffset: CGFloat = 0 //when 7
                let maxOffset: CGFloat = 10 //when 1
                // Using reversed interpolation: more items require less extra shift.
                let count = CGFloat(max(2, min(cartItemsAmount, 7)))
                return minOffset + (maxOffset - minOffset) * ((7 - count) / (7 - 2))
            }
            
            
            HStack(spacing: computedSpacing) {
                        ForEach(0..<min(cartItemsAmount, 7), id: \.self) { _ in
                            ItemBox(isSmall: true, isShowingDetail: false, isInCart: true)
                                .rotation3DEffect(
                                    .degrees(40),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                        }
                    }
                    .offset(x: computedXOffset, y: -30)
            
            
        }.overlay {
            if cartItemsAmount > 0 {
                HStack{
                    VStack (alignment: .leading){
                        Image(systemName: "\(cartItemsAmount).circle")
                        HStack (spacing: 0) {
                            Text("$\(Int.random(in: 1...99))")
                            Text(".\(Int.random(in: 1...99))")
                                .font(.caption)
                        }
                    }
                    
                    
                    Spacer()
                    
                    
                    
                    Button(action: {
                        
                    }){
                        Text("Go to \(Image(systemName: "cart.fill"))")
                            .padding(0)
                            .padding(.vertical)
                    }
                }
                .fontWeight(.thin)
                .frame(width: width - 20.0)
                .offset(z: depth/2)
            }
        }
        
        
      }
}

#Preview {
    Cart()
}
