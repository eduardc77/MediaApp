import Foundation
import Contentful

/// A small wrapper around the credentials for a space.
struct ContentfulCredentials: Codable, Equatable {
    
    static let defaultDomainHost = "contentful.com"
    
    let spaceId: String
    let environmentId: String
    let deliveryAPIAccessToken: String
    let previewAPIAccessToken: String
    let domainHost: String
    
    /// Pulls the default space credentials from the Example App Space owned by Contentful.
    static let `default`: ContentfulCredentials = {
        guard let bundleInfo = Bundle.main.infoDictionary else { fatalError() }
        
        let spaceId = bundleInfo["CONTENTFUL_SPACE_ID"] as! String
        let deliveryAPIAccessToken = bundleInfo["CONTENTFUL_DELIVERY_TOKEN"] as! String
        let previewAPIAccessToken = bundleInfo["CONTENTFUL_PREVIEW_TOKEN"] as! String
        let environmentId = "master"
        
        return ContentfulCredentials(
            spaceId: spaceId,
            environmentId: environmentId,
            deliveryAPIAccessToken: deliveryAPIAccessToken,
            previewAPIAccessToken: previewAPIAccessToken,
            domainHost: ContentfulCredentials.defaultDomainHost
        )
    }()
    
    /// Test Credentials
    static let test: ContentfulCredentials = {
        let spaceId = "twkkaqn5l2t4"
        let deliveryAPIAccessToken = "afmXAIHJlTPxX99MCeOufPqCU1JxTFAAl09JJqDdiWU"
        let previewAPIAccessToken = "NEj7wiUj79ydYT8U9FJ2n-F84trCX3I9qzEICchkd3E"
        let environmentId = "master"
        
        return ContentfulCredentials(
            spaceId: spaceId,
            environmentId: environmentId,
            deliveryAPIAccessToken: deliveryAPIAccessToken,
            previewAPIAccessToken: previewAPIAccessToken,
            domainHost: ContentfulCredentials.defaultDomainHost
        )
    }()
}
