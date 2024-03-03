
import SwiftUI

public struct CTAButton: View {
    public var title: String
    public var action: () -> Void
    public var foregroundColor: Color = .white
    public var lineWidth: CGFloat = 1.25
    
    public var body: some View {
        Button {
            action()
            
        } label: {
            HStack(spacing: 8) {
                Text(title)
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule()
                .strokeBorder(foregroundColor, lineWidth: lineWidth))
        }
        .foregroundStyle(foregroundColor)
    }
}

// MARK: - Preview

#if DEBUG
struct CTAButton_Previews: PreviewProvider {
    static var previews: some View {
        CTAButton(title: "Start", action: {}).preferredColorScheme(.dark).previewLayout(.sizeThatFits)
    }
}
#endif
