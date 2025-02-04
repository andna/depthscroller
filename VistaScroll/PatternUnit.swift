struct PatternUnit: View {
    let index: Int
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
            
            Rectangle()
                .frame(width: 400 + (isFirst ? circleRadius : 0), height: lineHeight)
            
            quarterCircle(startAngle: isEven ? 270 : 0,
                          endAngle: isEven ? 0 : 90,
                          offsetX: -circleRadius,
                          offsetY: isEven ? circleOffset : -circleOffset,
                          lineHeight: lineHeight,
                          circleDiameter: circleDiameter)
        }
        .foregroundColor(.white)
        .offset(x: isFirst ? lineHeight : 0)
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