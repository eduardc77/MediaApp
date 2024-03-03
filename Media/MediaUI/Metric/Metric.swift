
import SwiftUI

public enum Metric {
    
    // MARK: - Screen Size
    
    public static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    public static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    
    // MARK: - Article Preview Header
    
    public static let mediaPreviewHeaderHeight: CGFloat = screenHeight / 2.2
    public static let defaultArticlePageHeight: CGFloat = 9_999
}


public struct Size {
    public var width: CGFloat? = nil
    public var height: CGFloat? = nil
}
