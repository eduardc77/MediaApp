
public struct News {}

// MARK: - Environment

public extension News {
    
    enum Environment: APIEnvironment {
        case production
        case preproduction
        case develop
        
        public var baseURL: String {
            switch self {
            case .production: return ""
            case .preproduction: return ""
            case .develop: return "newsapi.org"
            }
        }
        
        public var headers: [String: String]? {
            switch self {
            case .production: return nil
            case .preproduction: return nil
            case .develop:
                return [
                    "Authorization": "Bearer \(DemoAPIKeys.newsAPIKey)"
                ]
            }
        }
        
        public var apiVersion: String { "/v2" }
    }
}


// MARK: - Route

public extension News {
    
    enum Route: APIRoute {
        
        case allNews(country: NewsCountry)
        case searchNews(query: String)
        case newsByCategory(category: String, country: NewsCountry)
        
        public var path: String {
            switch self {
            case .searchNews:
                return "/everything"
            case .allNews, .newsByCategory:
                return "/top-headlines"
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
        
        public var httpMethod: HTTPMethod {
            switch self {
            case .allNews, .searchNews, .newsByCategory:
                return .get
            }
        }
        
        public var mockFile: String? {
            switch self {
            case .allNews:
                return "_mockAllNewsResponse"
            case .newsByCategory:
                return "_mockNewsByCategoryResponse"
            default: return ""
            }
        }
    }
}
