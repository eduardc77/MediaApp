//
//  RichText.swift
//  BlogApp
//

import Contentful

public final class RichText: Resource, EntryDecodable, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "componentRichText"

    public let sys: Sys
    public var richText: RichTextDocument?
    
    public var state = ResourceState.upToDate

    public required init(from decoder: Decoder) throws {
        sys                     = try decoder.sys()
        let fields              = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        richText                = try fields.decodeIfPresent(RichTextDocument.self, forKey: .richText)
    }
    
    public enum FieldKeys: String, CodingKey {
        case richText
    }
}
