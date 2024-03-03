
import Contentful

public final class PageLayout: EntryDecodable, Resource, FieldKeysQueryable, StatefulResource {
    public static let contentTypeId = "pageLayout"

    public let sys: Sys
    public let slug: String
    public var sections: [LayoutSection]?

    public var state = ResourceState.upToDate
    
    public required init(from decoder: Decoder) throws {
        sys             = try decoder.sys()
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        slug            = try fields.decode(String.self, forKey: .slug)
        
        try fields.resolveLinksArray(forKey: .sections, decoder: decoder) { [weak self] sections in
            self?.sections = sections as? [LayoutSection]
        }
    }

    public enum FieldKeys: String, CodingKey {
        case slug, sections
    }
}
