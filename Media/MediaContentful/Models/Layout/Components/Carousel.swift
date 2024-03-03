//
//  Carousel.swift
//  MediaApp
//

import Contentful

public final class Carousel: Component, FieldKeysQueryable, EntryDecodable {
    public static let contentTypeId = "componentCarousel"

    public var title: String?
    public var size: CarouselSize?
    public var groupData: GroupData?

    public required init(from decoder: Decoder) throws {
        let fields      = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        title           = try fields.decodeIfPresent(String.self, forKey: .title)
        size            = try fields.decodeIfPresent(CarouselSize.self, forKey: .size)
 
        try super.init(sys: decoder.sys())

        try fields.resolveLink(forKey: .groupData, decoder: decoder) { [weak self] groupData in
            self?.groupData = groupData as? GroupData
        }
    }

    public enum FieldKeys: String, CodingKey {
        case title, size, groupData
    }
}

public enum CarouselSize: String, Decodable {
    case small, medium, large
}
