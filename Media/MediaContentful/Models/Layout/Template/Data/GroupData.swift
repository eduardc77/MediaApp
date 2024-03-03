//
//  GroupData.swift
//  BlogApp
//

import Contentful

public final class GroupData: EntryDecodable, Resource, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "groupData"

    public let sys: Sys
    public var items: [GroupItem]?
    
    public var state = ResourceState.upToDate

    public required init(from decoder: Decoder) throws {
        sys             = try decoder.sys()
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        
        try fields.resolveLinksArray(forKey: .items, decoder: decoder) { [weak self] items in
            self?.items = items as? [GroupItem]
        }
    }

    public enum FieldKeys: String, CodingKey {
        case items
    }
}


public class GroupItem: Resource, StatefulResource {
    public let sys: Sys
    public var state = ResourceState.upToDate
    
    public init(sys: Sys) {
        self.sys = sys
    }
}
