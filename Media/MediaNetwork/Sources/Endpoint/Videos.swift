
public struct Videos {}

// MARK: - Environment

public extension Videos {
    
    enum Environment: APIEnvironment {
        
        case develop(apiKey: String)
        
        public var baseURL: String {
            switch self {
            case .develop: return "api.themoviedb.org"
            }
        }

        public var queryParams: [String: String]? {
            switch self {
            case .develop(let key): 
                return [
                    "api_key": key
                ]
            }
        }
        
        public var apiVersion: String { "/3" }
    }
}

// MARK: - Route

public extension Videos {
    
    enum Route: APIRoute {
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
                return "/discover/movie"
            case .nowPlaying:
                return "/movie/now_playing"
            case .popular:
                return "/movie/popular"
            case .topRated:
                return "/movie/top_rated"
            case .upcoming:
                return "/movie/upcoming"
            case .movie(let id):
                return "/movie/\(id)"
            case .movieCredits(let id):
                return "/movie/\(id)/credits"
            case .movieVideos(let id):
                return "/movie/\(id)/movies"
            case .searchMovies:
                return "/search/movie"
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
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .discoverMovies, .nowPlaying, .popular, .topRated, .upcoming, .movie, .movieCredits, .movieVideos, .searchMovies:
                return .get
            }
        }
        
        public var mockFile: String? {
            switch self {
            case .discoverMovies:
                return "_mockVideosResponse"
            default: return ""
            }
        }
    }
}
