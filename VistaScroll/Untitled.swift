import SwiftUI

struct FadedScrollView: View {
    var body: some View {
        ZStack {
            // ScrollView with content
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<50) { index in
                        Text("Item \(index)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .mask(
                // Apply a gradient mask to create fading edges
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0), // Top fade
                        Color.black,            // Fully visible center
                        Color.black,            // Fully visible center
                        Color.black.opacity(0)  // Bottom fade
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Background color
    }
}


struct FadedScrollViews: PreviewProvider {
    static var previews: some View {
        FadedScrollView()
    }
}
