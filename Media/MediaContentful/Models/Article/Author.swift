//
//  Author.swift
//  MediaApp
//

import Contentful

public final class Author: GroupItem, EntryDecodable, FieldKeysQueryable {
    public static let contentTypeId = "componentAuthor"

    public var name: String?
    public var avatar: Asset?
    
    public required init(from decoder: Decoder) throws {
        let fields          = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        name                = try fields.decodeIfPresent(String.self, forKey: .name)
        
        try super.init(sys: decoder.sys())
        
        try fields.resolveLink(forKey: .avatar, decoder: decoder) { [weak self] avatar in
            self?.avatar = avatar as? Asset
        }
    }
    
    public enum FieldKeys: String, CodingKey {
        case name, avatar
    }
}
