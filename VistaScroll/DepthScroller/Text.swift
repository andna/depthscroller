import SwiftUI
import RealityKit

func randomPastelUIColor() -> UIColor {
    UIColor(red: CGFloat.random(in: 0.2...1.0),
            green: CGFloat.random(in: 0.2...1.0),
            blue: CGFloat.random(in: 0.2...1.0),
            alpha: 1.0)
}

struct Text3DView: View {
    var text = "Low\nPoly"
    var fontSize: Float = 0.02
    var sliderValue: Int = 0
    var isBig = false
    let color = randomPastelUIColor()
    
    let presetPositions: [SIMD3<Float>] = [
        SIMD3(0, 0, 0),
        SIMD3(0, -0.1, 0.15),
        SIMD3(0, -0.1, -0.1),
        SIMD3(0.2, 0.4, -0.4),
        SIMD3(0, 0, -0.2)
    ]
    
    let presetRotations: [simd_quatf] = [
        simd_quatf(angle: 0, axis: SIMD3(0, 1, 0)),
        simd_quatf(angle: -.pi/2, axis: SIMD3(1, 0, 0)),
        simd_quatf(angle: .pi/4, axis: SIMD3(1, 1, 0)),
        simd_quatf(angle: .pi/3, axis: SIMD3(0, 1, 0)),
        simd_quatf(angle: -.pi/2.5, axis: SIMD3(1, 0, 0))
    ]
    
    let presetScales: [SIMD3<Float>] = [
        SIMD3(1, 1, 1),
        SIMD3(0.2, 0.2, 0.2),
        SIMD3(1.8, 1.8, 1.8),
        SIMD3(4, 4, 4),
        SIMD3(2.5, 2.5, 2.5)
    ]
    
    func presetTransform(for idx: Int) -> Transform {
        Transform(scale: presetScales[idx], rotation: presetRotations[idx], translation: presetPositions[idx])
    }
    
    @State private var pivotContainer: Entity?
    @State private var shouldRotate = true
    @State private var previousSliderValue = 0
    
    var body: some View {
        VStack {
            RealityView { content in
                let container: Entity = {
                    if let c = pivotContainer { return c }
                    let c = Entity()
                    pivotContainer = c
                    return c
                }()
                
                let customFont = UIFont(name: "Futura", size: CGFloat(fontSize)) ?? .systemFont(ofSize: CGFloat(fontSize), weight: .bold)
                let mesh = MeshResource.generateText(text, extrusionDepth: 0.015, font: customFont, containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
                let material = SimpleMaterial(color: color, roughness: 0.2, isMetallic: true)
                let textEntity = ModelEntity(mesh: mesh, materials: [material])
                let center = textEntity.visualBounds(relativeTo: nil).center
                textEntity.transform.translation -= center
                if container.children.isEmpty { container.addChild(textEntity) }
                
                if sliderValue == 0 && shouldRotate {
                    addContinuousRotation(to: container)
                }
                if container.transform != presetTransform(for: sliderValue) {
                    container.transform = presetTransform(for: sliderValue)
                }
                content.add(container)
            }
            .onChange(of: sliderValue) { newVal in
                guard let container = pivotContainer else { return }
                if previousSliderValue == 0 && newVal != 0 {
                    shouldRotate = false
                    container.move(to: presetTransform(for: 0), relativeTo: container.parent, duration: 0.3, timingFunction: .easeInOut)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        container.move(to: presetTransform(for: newVal), relativeTo: container.parent, duration: 0.3, timingFunction: .easeInOut)
                    }
                } else if newVal == 0 {
                    container.move(to: presetTransform(for: 0), relativeTo: container.parent, duration: 0.3, timingFunction: .easeInOut)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        shouldRotate = true
                        addContinuousRotation(to: container)
                    }
                } else {
                    container.move(to: presetTransform(for: newVal), relativeTo: container.parent, duration: 0.3, timingFunction: .easeInOut)
                }
                previousSliderValue = newVal
            }
            .transition(.asymmetric(insertion: .opacity.combined(with: .scale), removal: .opacity.combined(with: .scale)))
            .animation(.easeInOut(duration: 0.5), value: sliderValue)
            .offset(z: -250)
        }
    }
    
    private func addContinuousRotation(to entity: Entity) {
        guard shouldRotate else { return }
        let angle: Float = .pi / 360
        entity.transform.rotation = simd_mul(entity.transform.rotation, simd_quatf(angle: angle, axis: SIMD3(0, 1, 0)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            addContinuousRotation(to: entity)
        }
    }
}
