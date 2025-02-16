import SwiftUI
import RealityKit

struct Tests: View {
    var body: some View {
        VStack {
            RealityView { content in
                
                let lines = ["Low", "Poly"]
                let lineSpacing: Float = -0.03 // Adjust spacing as needed

                // Create a container entity to hold all line
                let container = Entity()
                
                for (index, line) in lines.enumerated() {
                    let mesh = MeshResource.generateText(
                        line,
                        extrusionDepth: 0.05,
                        font: .systemFont(ofSize: 0.15, weight: .bold)
                    )
                    let material = SimpleMaterial(color: .white, isMetallic: false)
                    let entity = ModelEntity(mesh: mesh, materials: [material])
                    
                    // Offset each line manually by index.
                    entity.transform.translation = SIMD3<Float>(0, -Float(index) * (0.15 + lineSpacing), 0)
                    
                    container.addChild(entity)
                }
                
                // Center the container's pivot.
                let bounds = container.visualBounds(relativeTo: nil)
                let center = bounds.center
                container.transform.translation = -center
                
                // Apply a rotation to the container.
                container.transform.rotation = simd_quatf(angle: .pi / -8, axis: [0, 1, 0])
                
                let anchor = AnchorEntity(world: [0, 0, -2.0])
                anchor.addChild(container)
                content.add(anchor)
            }
            .ignoresSafeArea()
        }
    }
}

struct Tests_Previews: PreviewProvider {
    static var previews: some View {
        Tests()
    }
}
