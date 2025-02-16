import SwiftUI

var buttonSize = 44.0
var depthsPerIsle: Double = 10.0
var sidePanelRotation = 45.0

struct ContentView: View {
    
    @State private var isFullMap: Bool = false
    @State private var isShowingDetail: Bool = true
    @State private var currentDepth: Double = 1.0
    
    @State private var animationSelected = 0
    @State private var cartItemsAmount = 0
    
    var body: some View {
 
        HStack(alignment: .bottom) {
                VStack (spacing: isShowingDetail ? -160 : -10) {
                    
                    if isShowingDetail {
                        VStack{
                            
                                Image(systemName: "visionpro")
                                    .frame(width: 40, height: 40)
                                    .offset(z: 1)
                                    .offset(y: 60)
                            
                            Picker(selection: $animationSelected, label: Text("Animation")) {
                                Text("Rotate").tag(0)
                                    .fontWeight(animationSelected == 0 ? .black : .thin)
                                Text("Real-size").tag(1).fontWeight(animationSelected == 1 ? .black : .thin)
                                Text("Detail X").tag(2).fontWeight(animationSelected == 2 ? .black : .thin)
                                Text("Detail Y").tag(3).fontWeight(animationSelected == 3 ? .black : .thin)
                                Text("Detail Z").tag(4).fontWeight(animationSelected == 4 ? .black : .thin)
                                
                            }
                            //.pickerStyle(.segmented)
                            .pickerStyle(.inline)
                            .frame(width: 120)
                            // .background(.black.opacity(0.9))
                            .glassBackgroundEffect()
                        }
                            
                        
                        
                    }
                    
                    if !isFullMap {
                        DepthScroller(currentDepth: $currentDepth, isShowingDetail: $isShowingDetail)
                            .scaleEffect(isShowingDetail ? 0.3 : 1)
                    }
                    
                    if isShowingDetail {
                        Button(action: {
                            withAnimation{
                                isShowingDetail.toggle()
                            }
                        }){
                            Text("\(Image(systemName: "arrow.backward")) Isles")
                                .fontWeight(.thin)
                        }
                    } else {
                        DepthNavigation(isFullMap: $isFullMap, currentDepth: $currentDepth)
                    }
                }
                .offset(z: isShowingDetail ? 140 : 0)
                .offset(x: isShowingDetail ? -110 : 0, y: isShowingDetail ? 0 : 70)
                .rotation3DEffect(
                    .degrees(isShowingDetail ? sidePanelRotation : 0), axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            
            
      
            
            if !isFullMap && isShowingDetail {
                    
                
                        VStack{
                            ZStack{
                                ZStack{
                                    Text3DView(text: "High\nPolygon\n3DModel", fontSize: isShowingDetail ? 0.07 : 0.001, sliderValue: animationSelected, isBig: true)
                                    
                                    if animationSelected == 3 {
                                        
                                        Text3DView(text: "{", fontSize: 0.03, sliderValue: 0, isBig: false)
                                            .offset(z: -180)
                                            .offset(x: -90, y: -40)
                                    }
                                }
                                
                                
                                if animationSelected == 2 || animationSelected == 4 {
                                    let isBig = animationSelected == 2;
                                    HStack (alignment: isBig ? .top : .bottom, spacing: -16)  {
                                        
                                        Image(systemName: "line.diagonal.arrow")
                                            .rotationEffect(.degrees(isBig ? -90 : 180))
                                            .offset(y: 0)
                                        
                                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna")
                                            .font(.caption)
                                            .kerning(-0.3)
                                            .padding()
                                            .foregroundColor(.black)
                                            .background(Color.white)
                                            .clipShape(.rect(cornerRadius: 4.0))
                                            .frame(width: 180)
                                            .padding(13)
                                        
                                    }
                                    .offset(z: -450)
                                    .offset(x: 110, y: isBig ? 140 : -40)
                                }
                            }
                            
                        }.frame(width: 400, height: 700)
                            .offset(y: 80)
                            .clipped()
                       
                    
                Spacer().frame(width: 350)
                    
                
                
            }
    
        }
        .onChange(of: isShowingDetail){
            animationSelected = 0
        }
        .ornament(attachmentAnchor: .scene(.trailing), ornament: {
            
            
            if !isFullMap {
                
                VStack{
                    
                    let infoWidth = 200.0
                    
                    
                    Cart(cartItemsAmount: cartItemsAmount, width: infoWidth)
                        .overlay{
                            
                            if isShowingDetail {
                                
                                HStack (alignment: .top){
                                    
                                    
                                    VStack{
                                        
                                        VStack{
                                            Text("Full Details\n\n(WebView)")
                                        }
                                        .frame(width: infoWidth + 20, height: 550)
                                    }
                                    
                                    Divider()
                                    
                                    VStack{
                                        VStack{
                                            
                                            Text("To Add info")
                                                .fontWeight(.black)
                                            + Text("\n- Price\n- Deals\n- Shipping\n- Quantity Stepper")
                                            Spacer()
                                            Button(action: {
                                                cartItemsAmount += 1
                                            }){
                                                Text("Add to Cart")
                                                    .padding()
                                            }
                                        }
                                        .padding()
                                        .frame(width: infoWidth + 20, height: 380)
                                    }.padding()
                                    
                                }
                                .glassBackgroundEffect()
                                .offset(z: -45)
                                .offset(x: -110, y: -210)
                            }
                        }
                    
                }.rotation3DEffect(
                    .degrees(-sidePanelRotation), axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .frame(width: 550, height: 850)
                .offset(z: 250)
                .offset(x: -60, y: 330)
                
            }
            
        })
        
            
        
    }
}

#Preview(windowStyle: .plain) {
    ContentView()
}
