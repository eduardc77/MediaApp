import SwiftUI

protocol DecorationRendering {
    func draw(in context: CGContext, boundingRect: CGRect, textContainer: NSTextContainer)
}
