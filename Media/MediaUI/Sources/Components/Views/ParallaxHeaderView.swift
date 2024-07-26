
import SwiftUI

public struct ParallaxHeaderView<Content: View>: View {
    private let coordinateSpace: Namespace.ID
    private let height: CGFloat
    private let content: () -> Content
    
    public init(
        coordinateSpace: Namespace.ID,
        height: CGFloat,
        @ViewBuilder _ content: @escaping () -> Content
    ) {
        self.coordinateSpace = coordinateSpace
        self.height = height
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let offset = offset(for: proxy)
            let heightModifier = heightModifier(for: proxy)
            
            content()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + heightModifier
                )
                .offset(y: offset)
        }
        .frame(height: height)
    }
    
    private func offset(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        if frame.origin.y < 0 {
            return -frame.origin.y * 0.8
        }
        return -frame.origin.y
    }
    
    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.origin.y)
    }
}

// MARK: - Previews

struct ParallaxHeaderView_Previews: PreviewProvider {
    struct ParallaxHeaderViewExample: View {
        @Namespace private var scrollSpace
        
        var body: some View {
            ScrollView {
                ParallaxHeaderView(
                    coordinateSpace: scrollSpace,
                    height: Metric.mediaPreviewHeaderHeight
                ) {
                    if let url = URL(string: "https://docs-assets.developer.apple.com/published/9c4143a9a48a080f153278c9732c03e7/Image-1~dark@2x.png") {
                        AsyncImageView(url: url)
                    } else {
                        Color.secondary
                    }
                }
                Rectangle()
                    .frame(height: 1000)
                    .foregroundStyle(.white)
            }
            .coordinateSpace(name: scrollSpace)
            .background(.white)
            .ignoresSafeArea()
        }
    }
    
    static var previews: some View {
        ParallaxHeaderViewExample()
    }
}
