//
//  ItemData.swift
//  BlogApp
//

import Contentful

public final class ItemData: EntryDecodable, Resource, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "data"

    public let sys: Sys
    public var item: GroupItem?
    
    public var state = ResourceState.upToDate
    
    public required init(from decoder: Decoder) throws {
        sys             = try decoder.sys()
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        
        try fields.resolveLink(forKey: .item, decoder: decoder) { [weak self] item in
            self?.item = item as? GroupItem
        }
    }

    public enum FieldKeys: String, CodingKey {
        case item
    }
}
