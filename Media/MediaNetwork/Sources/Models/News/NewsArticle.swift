
public struct NewsArticle: Codable, Hashable {
    public let source: Source?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
    public let content: String?
}

public struct Source: Codable, Hashable {
    public let id: String?
    public let name: String?
}
