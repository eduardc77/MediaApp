
import Foundation

public struct VideosService {}

// MARK: - Environment

public extension VideosService {
    
    enum Environment: ApiEnvironment {
        
        case develop(apiKey: String)
        
        public var url: String {
            switch self {
            case .develop: return "https://api.themoviedb.org/3"
            }
        }
        
        public var headers: [String: String]? { nil }
        
        public var queryParams: [String: String]? {
            // Attaching the API key via the 'api_key' query parameter.
            switch self {
            case .develop(let key): return ["api_key": key]
            }
        }
    }
}

// MARK: - Route

public extension VideosService {
    
    enum Route: ApiRoute {
        case discoverMovies(page: Int)
        case nowPlaying(page: Int)
        case popular(page: Int)
        case topRated(page: Int)
        case upcoming(page: Int)
        case movie(id: Int)
        case movieCredits(id: Int)
        case movieVideos(id: Int)
        case searchMovies(query: String, page: Int)
        
        public var path: String {
            switch self {
            case .discoverMovies: 
                return "discover/movie"
            case .nowPlaying:
                return "movie/now_playing"
            case .popular:
                return "movie/popular"
            case .topRated:
                return "movie/top_rated"
            case .upcoming:
                return "movie/upcoming"
            case .movie(let id):
                return "movie/\(id)"
            case .movieCredits(let id):
                return "movie/\(id)/credits"
            case .movieVideos(let id): 
                return "movie/\(id)/movies"
            case .searchMovies: 
                return "search/movie"
            }
        }
        
        public var queryParams: [String: String]? {
            switch self {
            case .discoverMovies(let page):
                return ["language": "en-US", "sort-by": "popularity", "page": "\(page)"]
            case .nowPlaying(let page), .popular(let page), .topRated(let page), .upcoming(let page):
                return ["language": "en-US", "page": "\(page)"]
            case .movie, .movieCredits, .movieVideos:
                return nil
            case .searchMovies(let query, let page):
                return ["query": query, "page": "\(page)"]
            }
        }
        
        public var httpMethod: HttpMethod {
            switch self {
            case .discoverMovies, .nowPlaying, .popular, .topRated, .upcoming, .movie, .movieCredits, .movieVideos, .searchMovies:
                return .get
            }
        }
        
        public var headers: [String: String]? { nil }
        
        public var formParams: [String: String]? { nil }
        
        public var postData: Data? { nil }
    }
}
