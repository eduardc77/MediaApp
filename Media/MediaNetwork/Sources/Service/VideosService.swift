
import Foundation

public protocol VideosServiceable {
    
    func getVideo<T: Decodable>(id: Int) async throws -> T
    func getVideos<T: Decodable>(for route: Videos.Route) async throws -> T
    func searchVideos<T: Decodable>(query: String, page: Int) async throws -> T
    func getVideoCredits<T: Decodable>(id: Int) async throws -> T
    
}

public struct VideosService: APIClient, VideosServiceable {
    
    public var environment: Videos.Environment
    
    public var session: URLSession
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        //decoder.dateDecodingStrategy = .iso8601
        //decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
    
    public init(session: URLSession = URLSession.shared, environment: Videos.Environment = .develop(apiKey: DemoAPIKeys.theMovieDB)) {
        self.environment = environment
        self.session = session
    }
    
    public func getVideo<T>(id: Int) async throws -> T where T : Decodable {
        try await asyncFetchRequest(Videos.Route.movie(id: id), in: environment)
    }
    
    public func getVideos<T: Decodable>(for route: Videos.Route) async throws -> T {
        try await asyncFetchRequest(route, in: environment)
    }
    
    public func searchVideos<T: Decodable>(query: String, page: Int) async throws -> T {
        try await asyncFetchRequest(Videos.Route.searchMovies(query: query, page: page), in: environment)
    }
    
    public func getVideoCredits<T: Decodable>(id: Int) async throws -> T {
        try await asyncFetchRequest(Videos.Route.movieCredits(id: id), in: environment)
        
    }
}


public final class VideosServiceMock: Mockable, VideosServiceable {
    
    public init() {
        
    }
    
    public func getVideo<T>(id: Int) async throws -> T where T : Decodable {
        loadJSON(filename: "top_rated_response", type: T.self)
    }
    
    public func getVideos<T: Decodable>(for route: Videos.Route) async throws -> T {
        loadJSON(filename: "top_rated_response", type: T.self)
    }
    
    public func searchVideos<T: Decodable>(query: String, page: Int) async throws -> T {
        loadJSON(filename: "search_response", type: T.self)
    }
    
    public func getVideoCredits<T>(id: Int) async throws -> T where T : Decodable {
        loadJSON(filename: "search_response", type: T.self)
    }
}
