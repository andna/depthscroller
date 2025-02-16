//
//  ItemBox.swift
//  VistaScroll
//
//  Created by Andres Bastidas on 5/02/25.
//

import SwiftUI

let itemTitles = [
    "Apple - 6 count",
    "Bananas - 1 lb",
    "Whole Milk - 1 gallon",
    "Shredded Cheddar Cheese - 8 oz",
    "Eggs - 12 count",
    "Chicken Breast - 1 lb",
    "Loaf of Bread - White",
    "Peanut Butter - 16 oz",
    "Toothpaste - 6 oz",
    "Body Wash - 16 oz",
    "Laundry Detergent - 64 oz",
    "Dish Soap - 25 oz",
    "Paper Towels - 6 rolls",
    "Toilet Paper - 12 rolls",
    "Plastic Storage Bags - 50 count",
    "Round Coffee Table",
    "USB-C Charging Cable",
    "Notebook - College Ruled",
    "Pack of Pens - 12 count",
    "Laptop Backpack",
    "LED Light Bulbs - 4 pack",
    "Instant Coffee - 12 oz",
    "Frozen Pizza - Pepperoni",
    "Deli Ham - 1 lb",
    "Ice Cream - Vanilla, 1 pint"
]


let shippingTitles = [
    ""
]

struct ItemInfo: View {
    
    var isSmall: Bool = false
    var isInCart: Bool? = false
    
    var body: some View {
        Group{
            HStack{
                HStack(alignment: .center, spacing: 0) {
                    Text("$")
                    Text("\(Int.random(in: 1...99))")
                        .font(.headline)
                    Text(".\(Int.random(in: 1...99))")
                    
                }
                .font(.caption)
                .fontWeight(.black)
                .kerning(-0.3)
                
                if !isSmall {
                    Spacer()
                    
                    Text("\(Int.random(in: 0...5))d \(   Image(systemName: "shippingbox"))")
                        .font(.caption2)
                        .fontWeight(.light)
                }
            }
            
            if !isInCart! {
                if let randomItem = itemTitles.randomElement() {
                    Text("\(randomItem)")
                        .font(.caption)
                }
            }
        }
       
    }
        
}

struct ItemBox: View {
    var isSmall: Bool = false
    var isShowingDetail: Bool = false
    var isInCart: Bool? = false
    
    @State private var isHovering = false


    var body: some View {
        
        let boxWidth = gridSize / (isSmall ? 2 : 1);
        let imageWidth = boxWidth - 16;
        let isImage = isSmall || isShowingDetail;
        Group{
            VStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8.0)
                    .fill(isImage ? .white.opacity(0.1) : .clear)
                        .frame(width: imageWidth, height: imageWidth)
                        .overlay{
                            
                            if isImage {
                                Text("Image")
                                    .fontWeight(.black)
                                    .foregroundColor(Color(randomPastelUIColor()))
                            } else {
                               Text3DView()
                            }
                        }
                 
                    
                
                
                if !isInCart! {
                    ItemInfo(isSmall: isSmall, isInCart: isInCart)
                    
                    Spacer()
                        
                    HStack (spacing: -1){
                        
                        if !isSmall {
                            ForEach(1...5, id: \.self) { _ in
                                Image(systemName: "star")
                                    .font(.caption2)
                            }.opacity(isHovering ? 0 : 1)
                            
                        }
                        Spacer()
                        
                        Image(systemName: "heart")
                            .opacity(isHovering && isSmall ? 0 : 1)
                    }
                    .fontWeight(.light)
                } else {
                    
                    Spacer()
                }
            }
            .padding(8)
            
            .frame(width: boxWidth, height: isInCart! ? 130.0 : gridSize * 1.6)
            .background(.black.opacity(isInCart! ? 0.92 : 0.8))
            .clipShape(.rect(cornerRadius: 10.0))
            .brightness(isHovering ? 0.3 : 0.0)
            .overlay{
                
                if isHovering {
                    Button(action: {}, label: {
                        Text(isSmall ? "Add" : "Add to Cart")
                            .font(.caption2)
                    })
                    .offset(x: -20, y: 100)
                }
            }
        }
        .onHover { hovering in
            withAnimation{
                isHovering = hovering
            }
        }

           /* .glassBackgroundEffect(in: .rect(cornerRadius: 10.0))
            */
    }
}

#Preview {
    ItemBox()
}
