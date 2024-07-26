
import Contentful

public final class VideoBanner: Component, FieldKeysQueryable, EntryDecodable {
    public static let contentTypeId = "componentVideoBanner"

    public var headline: String?
    public var thumbnail: Asset?
    public var featuredVideoURL: String?
    public var ctaText: String?
    public var dataLink: ItemData?
    public var backgroundColor: String?

    public required init(from decoder: Decoder) throws {
        let fields       = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        headline         = try fields.decodeIfPresent(String.self, forKey: .headline)
        featuredVideoURL = try fields.decodeIfPresent(String.self, forKey: .featuredVideoURL)
        ctaText          = try fields.decodeIfPresent(String.self, forKey: .ctaText)
        backgroundColor  = try fields.decodeIfPresent(String.self, forKey: .backgroundColor)
        
        try super.init(sys: decoder.sys())

        try fields.resolveLink(forKey: .dataLink, decoder: decoder) { [weak self] dataLink in
            self?.dataLink = dataLink as? ItemData
        }
        try fields.resolveLink(forKey: .thumbnail, decoder: decoder) { [weak self] thumbnail in
            self?.thumbnail = thumbnail as? Asset
        }
    }

    public enum FieldKeys: String, CodingKey {
        case headline, thumbnail, featuredVideoURL, ctaText, dataLink, backgroundColor
    }
}

