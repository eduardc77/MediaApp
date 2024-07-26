
import Foundation

public struct CastModel: Codable {
    public let cast, crew: [Cast]?
    public let id: Int?
}

public struct Cast: Codable {
    public let adult: Bool?
    public let gender, id: Int?
    public let knownForDepartment, name, originalName: String?
    public let popularity: Double?
    public let profilePath: String?
    public let character, creditID: String?
    public let order: Int?
    public let department, job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    public init(adult: Bool? = nil,
                gender: Int? = nil,
                id: Int? = nil,
                knownForDepartment: String? = nil,
                name: String? = "",
                originalName: String? = nil,
                popularity: Double? = nil,
                profilePath: String? = nil,
                job: String? = nil,
                character: String? = nil,
                creditID: String? = nil,
                order: Int? = nil,
                department: String? = nil) {
        
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.character = character
        self.creditID = creditID
        self.order = order
        self.job = job
        self.department = department
    }
    
    public func imageUrl(path: String, width: Int) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w\(width)" + path)
    }
}
