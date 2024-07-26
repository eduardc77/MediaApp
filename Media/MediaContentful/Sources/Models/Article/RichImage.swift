//
//  RichImage.swift
//  MediaApp
//

import Contentful

public final class RichImage: Resource, EntryDecodable, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "componentRichImage"

    public let sys: Sys
    public var image: Asset?
    public var caption: String?
    
    public var state = ResourceState.upToDate

    public required init(from decoder: Decoder) throws {
        sys = try decoder.sys()

        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        caption = try fields.decodeIfPresent(String.self, forKey: .caption)
        
        try fields.resolveLink(forKey: .image, decoder: decoder) { [weak self] image in
            self?.image = image as? Asset
        }
    }
    
    public enum FieldKeys: String, CodingKey {
        case image, caption
    }
}
