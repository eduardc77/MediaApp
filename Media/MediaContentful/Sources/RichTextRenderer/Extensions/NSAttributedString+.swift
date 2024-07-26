
import Foundation

extension NSAttributedString {
    
    /// Returns range representing entire string.
    var fullRange: NSRange {
        NSRange(location: 0, length: length)
    }
    
    /// Trims beginning and ending whitespace
    func trim() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let startRange = string.rangeOfCharacter(from: invertedSet)
        let endRange = string.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let startLocation = startRange?.lowerBound, let endLocation = endRange?.lowerBound else {
            return NSAttributedString(string: string)
        }

        let trimmedRange = startLocation...endLocation
        return attributedSubstring(from: NSRange(trimmedRange, in: string))
    }
}

public extension NSAttributedString.Key {
    static let block = NSAttributedString.Key(rawValue: "ContentfulBlockAttribute")
    static let embed = NSAttributedString.Key(rawValue: "ContentfulEmbed")
    static let horizontalRule = NSAttributedString.Key(rawValue: "ContentfulHorizontalRule")
}
