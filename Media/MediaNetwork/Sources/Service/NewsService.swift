
import Foundation

public protocol NewsServiceable {
    
    func getNews<T: Decodable>(for route: News.Route) async throws -> T
    
}

public struct NewsService: APIClient, NewsServiceable {
    
    public var environment: News.Environment
    
    public var session: URLSession
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        //decoder.dateDecodingStrategy = .iso8601
        //decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    public init(session: URLSession = URLSession.shared, environment: News.Environment = .develop) {
        self.environment = environment
        self.session = session
    }
    
    public func getNews<T: Decodable>(for route: News.Route) async throws -> T {
        try await asyncFetchRequest(route, in: environment)
    }
    
}


public final class NewsServiceMock: Mockable, NewsServiceable {
    
    public init() {
        
    }
    
    public func getNews<T: Decodable>(for route: News.Route) async throws -> T {
        loadJSON(filename: "all_news_response", type: T.self)
    }
}
