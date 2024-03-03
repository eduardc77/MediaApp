
import Foundation

public struct Video: Codable, Hashable, Identifiable {
    public let id: Int
    public let imdbId: String?
    public let title: String
    public let originalTitle: String?
    public let originalLanguage: String?
    public let overview: String?
    public let tagline: String?
    public let genres: [MovieGenre]?
    
    public let releaseDate: String?
    public let budget: Int?
    public let runtime: Int?
    public let revenue: Int?
    public let popularity: Double?
    public let averageRating: Double?
    public let voteCount: Int?
    
    public let homepageUrl: String?
    public let backdropPath: String?
    public let posterPath: String?
    public let profilePath: String?
    
    public let isAdultMovie: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imdbId = "imdb_id"
        case title
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview
        case tagline
        case genres
        
        case releaseDate = "release_date"
        case budget
        case runtime
        case revenue
        case popularity
        case averageRating = "vote_average"
        case voteCount = "vote_count"
        
        case homepageUrl = "homepage"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        
        case isAdultMovie = "adult"
    }
    
    public func backdropUrl(width: Int) -> URL? {
        imageUrl(path: backdropPath ?? "", width: width)
    }
    
    public func posterUrl(width: Int) -> URL? {
        imageUrl(path: posterPath ?? "", width: width)
    }
    
    func imageUrl(path: String, width: Int) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w\(width)" + path)
    }
}

public struct MovieGenre: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
}

public struct VideoPaginationResult: Codable {
    public let page: Int
    public let results: [Video]
    public let totalPages: Int
    public let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
