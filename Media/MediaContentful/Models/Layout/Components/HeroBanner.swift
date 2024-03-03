
import Contentful

public final class HeroBanner: Component, FieldKeysQueryable, EntryDecodable {
    public static let contentTypeId = "componentHeroBanner"

    public var headline: String?
    public var subheadline: String?
    public var ctaText: String?
    public var targetPage: ItemData?
    public var image: Asset?
    public var backgroundColor: String?

    public required init(from decoder: Decoder) throws {
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        headline        = try fields.decodeIfPresent(String.self, forKey: .headline)
        subheadline     = try fields.decodeIfPresent(String.self, forKey: .subheadline)
        ctaText         = try fields.decodeIfPresent(String.self, forKey: .ctaText)
        backgroundColor = try fields.decodeIfPresent(String.self, forKey: .backgroundColor)
        
        try super.init(sys: decoder.sys())

        try fields.resolveLink(forKey: .targetPage, decoder: decoder) { [weak self] targetPage in
            self?.targetPage = targetPage as? ItemData
        }
        try fields.resolveLink(forKey: .image, decoder: decoder) { [weak self] image in
            self?.image = image as? Asset
        }
    }

    public enum FieldKeys: String, CodingKey {
        case headline, subheadline, bodyText, ctaText, targetPage, image, backgroundColor
    }
}
