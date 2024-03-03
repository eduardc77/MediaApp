
import SwiftUI

public extension HeadingStyles {
    static var `default`: HeadingStyles {
        .init(
            h1: .systemFont(ofSize: 24, weight: .semibold), h1Color: UIColor.label,
            h2: .systemFont(ofSize: 18, weight: .semibold), h2Color: UIColor.label,
            h3: .systemFont(ofSize: 16, weight: .semibold), h3Color: UIColor.label,
            h4: .systemFont(ofSize: 15, weight: .semibold), h4Color: UIColor.label,
            h5: .systemFont(ofSize: 14, weight: .semibold), h5Color: UIColor.label,
            h6: .systemFont(ofSize: 13, weight: .semibold), h6Color: UIColor.label
        )
    }
}

