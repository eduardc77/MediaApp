
import Foundation

public enum ImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case custom(width: CGFloat? = nil, height: CGFloat? = nil)
    case none
    
    public var value: Size {
        switch self {
        case .xxSmall:
            return  Size(width: 28, height: 28)
        case .xSmall:
            return Size(width: 32, height: 32)
        case .small:
            return Size(width: 40, height: 40)
        case .medium:
            return Size(width: 48, height: 48)
        case .large:
            return Size(width: 64, height: 64)
        case .xLarge:
            return Size(width: 80, height: 80)
        case .xxLarge:
            return Size(width: 140, height: 140)
        case .custom(width: let width, height: let height):
            return Size(width: width, height: height)
        case .none:
            return Size()
        }
    }
}
