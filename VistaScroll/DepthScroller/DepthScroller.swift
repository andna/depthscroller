//
//  DepthScroller.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 12/01/25.
//

import SwiftUI


let gridSize = 160.0
let squareAmount = 2




struct DepthScroller: View {
    
    
    @Binding var currentDepth: Double
    @Binding var isShowingDetail: Bool
    
    let allItems: [Item] = (1...200).map { index in
        Item(id: index, label: "#\(index)")
    }

    let itemsLeft: [[Item]]
    let itemsRight: [[Item]]

    // Maximum number of depth levels (number of chunks)
     let maxDepth: Int
    

    var showDepthSlider = false
    
    init(currentDepth: Binding<Double>, isShowingDetail: Binding<Bool>, showDepthSlider: Bool? = false) {
        let chunkSize = squareAmount * 2
        let halfChunkSize = chunkSize / 2
        var leftItems: [[Item]] = []
        var rightItems: [[Item]] = []

        for chunkStart in stride(from: 0, to: allItems.count, by: chunkSize) {
            let chunkEnd = min(chunkStart + chunkSize, allItems.count)
            let chunk = Array(allItems[chunkStart..<chunkEnd])

            let leftChunk = Array(chunk.prefix(halfChunkSize))
            let rightChunk = Array(chunk.suffix(from: halfChunkSize))

            leftItems.append(leftChunk)
            rightItems.append(rightChunk)
        }

        self.itemsLeft = leftItems
        self.itemsRight = rightItems
        
        
        self.maxDepth = leftItems.count  // Total number of depth levels
        self._currentDepth = currentDepth
        self._isShowingDetail = isShowingDetail
        self.showDepthSlider = showDepthSlider!
    }
    
    var body: some View {
        
            VStack {
                HStack {
                    SideRow(items: Array(itemsLeft.prefix(Int(currentDepth))), currentDepth: Int(currentDepth), isShowingDetail: isShowingDetail)
                    SideRow(items: Array(itemsRight.prefix(Int(currentDepth))), isMirrored: true, currentDepth: Int(currentDepth), isShowingDetail: isShowingDetail)
                }
                .animation(.default, value: currentDepth)
                .onTapGesture {
                    withAnimation{
                        isShowingDetail.toggle()
                    }
                }

                if showDepthSlider{
                    VStack {
                        Slider(value: $currentDepth, in: 1...Double(maxDepth), step: 1)
                            .padding([.leading, .trailing])
                         
                        Text("Depth: \(Int(currentDepth)) / \(maxDepth)")
                    }
                    .padding()
                    
                }
            }
    }
}


struct Item: Identifiable {
    let id: Int
    let label: String
}

struct SideRowItemView: View {
    var item: [Item]
    var index: Int
    var isSmall: Bool
    var isShowingDetail: Bool
    
    @State private var isVisible: Bool = false

    
    var body: some View {
        
    

        let amount = Double(squareAmount)

        let unit = gridSize / 8.0

        let xCercanySmalls = amount * 3 * unit
        let offsetZ = isSmall ? CGFloat((7.0 - Double(index)) * 4 * unit - 5 * unit) : 0
        let offsetX = isSmall ? CGFloat(Double(index) * -2 * unit + xCercanySmalls) : 0
        let opacity = isSmall ? (Double(index) - 1.0) / (amount * 2.0) : 1.0
        
        
    
        VStack {
            ForEach(item) { subItem in
                if (isSmall ? !isShowingDetail : (!isShowingDetail || index == 7) ){
                    ItemBox(isSmall: isSmall, isShowingDetail: isShowingDetail)
                        .opacity(isVisible ? 1 : 0)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .rotation3DEffect(
            .degrees(isSmall ? 45 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .offset(z: offsetZ)
        .offset(x: offsetX)
        .opacity(opacity)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

struct SideRow: View {
    var items: [[Item]]
    var isMirrored: Bool = false
    var currentDepth: Int
    var isShowingDetail: Bool

    var body: some View {
        HStack {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                SideRowItemView(
                    item: item,
                    index: (8 - currentDepth) + index,
                    isSmall: currentDepth - index > squareAmount,
                    isShowingDetail: isShowingDetail
                )
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .modifier(active: BookOpenModifier(isVisible: false), identity: BookOpenModifier())),
                        removal: .opacity.combined(with: .modifier(active: BookOpenModifier(isVisible: false), identity: BookOpenModifier()))
                    )
                )


            }
        }
        .environment(\.layoutDirection, isMirrored ? .rightToLeft : .leftToRight)
        
    }
}
struct BookOpenModifier: ViewModifier {
    var isVisible: Bool = true

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isVisible ? 0 : 90),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .offset(z: isVisible ? 0 : -99)
    }
}
struct MyPreview: View {
    @State private var previewDepth: Double = 1.0
    @State private var previewDetails: Bool = false

    var body: some View {
        DepthScroller(currentDepth: $previewDepth, isShowingDetail: $previewDetails, showDepthSlider: true)
    }
}

#Preview {
    MyPreview()
}
