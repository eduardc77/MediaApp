
import SwiftUI

public struct NavigationButton<Label: View>: View {
    public var action: () -> Void
    public var label: Label

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    public var body: some View {
        Button(action: action, label: { label })
            .buttonStyle(.borderless)
    }
}
