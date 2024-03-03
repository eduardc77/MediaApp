//
//  Article.swift
//  MediaApp
//

import Foundation
import Contentful

public final class Article: GroupItem, EntryDecodable, FieldKeysQueryable {
    public static let contentTypeId = "pageArticle"
    
    public let slug: String
    public let title: String
    public var subtitle: String?
    public var body: RichText?
    public var author: Author?
    public var publishedDate: Date?

    public var featuredImage: Asset?
    public var relatedArticles: Carousel?
 
    public var hasRelatedArticles: Bool {
        guard let relatedArticles = relatedArticles?.groupData?.items else { return false }
        return relatedArticles.count > 0
    }
    
    public required init(from decoder: Decoder) throws {
        let fields          = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        slug                = try fields.decode(String.self, forKey: .slug)
        title               = try fields.decode(String.self, forKey: .title)
        subtitle            = try fields.decodeIfPresent(String.self, forKey: .subtitle)
        publishedDate       = try fields.decodeIfPresent(Date.self, forKey: .publishedDate)
        
        try super.init(sys: decoder.sys())
        
        try fields.resolveLink(forKey: .body, decoder: decoder) { [weak self] body in
            self?.body = body as? RichText
        }
        try fields.resolveLink(forKey: .author, decoder: decoder) { [weak self] author in
            self?.author = author as? Author
        }
        try fields.resolveLink(forKey: .featuredImage, decoder: decoder) { [weak self] asset in
            self?.featuredImage = asset as? Asset
        }
        try fields.resolveLink(forKey: .relatedArticles, decoder: decoder) { [weak self] array in
            self?.relatedArticles = array as? Carousel
        }
    }
    
    public enum FieldKeys: String, CodingKey {
        case title, subtitle, slug, publishedDate, body, author, featuredImage, relatedArticles
    }
}

extension Article: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sys.id)
    }
    
    public static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.sys.id == rhs.sys.id && lhs.slug == rhs.slug
    }
}
