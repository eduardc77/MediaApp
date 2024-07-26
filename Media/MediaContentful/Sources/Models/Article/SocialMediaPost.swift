//
//  SocialMediaPost.swift
//  MediaApp
//

import Contentful

public final class SocialMediaPost: Resource, EntryDecodable, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "componentSocialMediaPost"

    public let sys: Sys
    public var title: String?
    public var url: String?
    
    public var state = ResourceState.upToDate
    
    public required init(from decoder: Decoder) throws {
        sys = try decoder.sys()

        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        title = try fields.decodeIfPresent(String.self, forKey: .title)
        url = try fields.decodeIfPresent(String.self, forKey: .url)
    }
    
    public enum FieldKeys: String, CodingKey {
        case title, url
    }
}
