//
//  LayoutSection.swift
//  BlogApp
//

import Contentful

public final class LayoutSection: EntryDecodable, Resource, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "section"

    public let sys: Sys
    public var component: Component?
    
    public var state = ResourceState.upToDate
    
    public required init(from decoder: Decoder) throws {
        sys             = try decoder.sys()
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        
        try fields.resolveLink(forKey: .component, decoder: decoder) { [weak self] component in
            self?.component = component as? Component
        }
    }

    public enum FieldKeys: String, CodingKey {
        case component
    }
}

extension LayoutSection: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sys.id)
    }
    
    public static func == (lhs: LayoutSection, rhs: LayoutSection) -> Bool {
        return lhs.sys.id == rhs.sys.id
    }
}
