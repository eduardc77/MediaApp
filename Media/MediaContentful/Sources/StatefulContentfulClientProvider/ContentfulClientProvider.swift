
import Contentful

final class ContentfulClientProvider {
    
    let deliveryClient: Client
    let previewClient: Client
    
    init(credentials: ContentfulCredentials) {
        self.deliveryClient = Client(
            spaceId: credentials.spaceId,
            environmentId: credentials.environmentId,
            accessToken: credentials.deliveryAPIAccessToken,
            host: "cdn." + credentials.domainHost,
            contentTypeClasses: ContentfulClientProvider.contentTypeClasses
        )
        
        self.previewClient = Client(
            spaceId: credentials.spaceId,
            environmentId: credentials.environmentId,
            accessToken: credentials.previewAPIAccessToken,
            host: "preview." + credentials.domainHost,
            contentTypeClasses: ContentfulClientProvider.contentTypeClasses
        )
    }
    
    /// An array of all the content types that will be used by the apps instance of `ContentfulService`.
    private static var contentTypeClasses: [EntryDecodable.Type] = [
        Author.self,
        Article.self,
        Carousel.self,
        ItemData.self,
        GroupData.self,
        HeroBanner.self,
        PageLayout.self,
        LayoutSection.self,
        SocialMediaPost.self,
        RichImage.self,
        RichText.self,
        VideoBanner.self,
    ]
}
