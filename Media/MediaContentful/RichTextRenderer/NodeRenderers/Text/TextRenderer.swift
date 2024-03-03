
import Contentful
import SwiftUI

/// Renderer for a `Contentful.Text` node.
open class TextRenderer: NodeRendering {
    public typealias NodeType = Contentful.Text
    
    required public init() {}
    
    open func render(
        node: Contentful.Text,
        rootRenderer: RichTextDocumentRendering,
        context: [CodingUserInfoKey : Any]
    ) -> [NSMutableAttributedString] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = rootRenderer.configuration.textConfiguration.lineSpacing
        paragraphStyle.paragraphSpacing = rootRenderer.configuration.textConfiguration.paragraphSpacing
        
        let currentFont = rootRenderer.configuration.styleProvider.font(for: node)
        let currentColor = rootRenderer.configuration.styleProvider.color(for: node)
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: currentFont,
            .foregroundColor: currentColor,
            .paragraphStyle: paragraphStyle
        ]
        
        if node.marks.contains(Text.Mark(type: .underline)) {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            attributes[.underlineColor] = currentColor
        }
        
        let hasSubscript = node.marks.contains(Text.Mark(type: .subscript))
        let hasSuperscript = node.marks.contains(Text.Mark(type: .superscript))
        
        if hasSuperscript || hasSubscript {
            // We make the superscript/subscript font twice smaller than original
            let twiceSmallerFont = currentFont.withSize(currentFont.pointSize * 0.5)
            attributes[.font] = twiceSmallerFont
            // We also need to move superscript up and subscript down by the size of the new font
            let multiplier: CGFloat = hasSuperscript ? 1 : -1
            attributes[.baselineOffset] = twiceSmallerFont.pointSize * multiplier
        }
        
        return [
            .init(
                string: node.value,
                attributes: attributes
            )
        ]
    }
}
