
import Foundation

public struct NewsService {}

// MARK: - Environment

public extension NewsService {
    
    enum Environment: ApiEnvironment {
        case production
        case preproduction
        case develop
        
        public var url: String {
            switch self {
            case .production: return "https://newsapi.org"
            case .preproduction: return ""
            case .develop: return ""
            }
        }
        
        public var headers: [String: String]? {
            nil
            // Attaching the API key via the 'apiKey' query parameter.
            //            switch self {
            //            case .production(let key): return ["X-Api-Key": key]
            //            }
        }
        
        public var queryParams: [String: String]? {
            nil
            // Attaching the API key via the 'apiKey' query parameter.
            //            switch self {
            //            case .production(let key): return ["apiKey": key]
            //            }
        }
    }
}


// MARK: - Route

public extension NewsService {
    
    enum Route: ApiRoute {
        
        case allNews(country: NewsCountry)
        case searchNews(query: String)
        case newsByCategory(category: String, country: NewsCountry)
        
        public var path: String {
            switch self {
            case .searchNews:
                return "/v2/everything"
            case .allNews, .newsByCategory:
                return "/v2/top-headlines"
            }
        }
        
        public var queryParams: [String: String]? {
            switch self {
            case .allNews(let country):
                return ["country": country.code]
            case .searchNews(let query):
                return ["q": query]
            case .newsByCategory(let category, let country):
                return ["country": country.code, "category": category]
            }
        }
        
        public var httpMethod: HttpMethod {
            switch self {
            case .allNews, .searchNews, .newsByCategory:
                return .get
            }
        }
        
        public var headers: [String: String]? {
            // Attaching the API key via the Authorization HTTP header example.
            switch self {
            case .allNews, .searchNews, .newsByCategory:
                return [
                    "Authorization": "Bearer \(DemoAPIKeys.newsAPIKey)"
                ]
            }
        }
        
        public var formParams: [String: String]? { nil }
        
        public var postData: Data? { nil }
    }
}
