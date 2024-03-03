//
//  ArticleViewControllerRepresentable.swift
//  MediaApp
//

import SwiftUI
import Contentful
import MediaContentful

struct ArticleViewControllerRepresentable: UIViewControllerRepresentable {
    private let content: RichTextDocument?
    private let isScrollEnabled: Bool
    @ObservedObject var heightObservable: RichTextHeightObservable
    
    init(content: RichTextDocument? = nil,
         isScrollEnabled: Bool = false,
         heightObservable: RichTextHeightObservable? = nil
    ) {
        self.content = content
        self.isScrollEnabled = isScrollEnabled
        self.heightObservable = heightObservable ?? RichTextHeightObservable()
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        guard let content = content else { return TextViewController() }
        let viewController = TextViewController(content: content, isScrollEnabled: isScrollEnabled, heightObservable: heightObservable)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

private class TextViewController: RichTextViewController {
    var content: RichTextDocument?
    
    init(content: RichTextDocument? = nil,
         isScrollEnabled: Bool = false,
         heightObservable: RichTextHeightObservable? = nil
    ) {
        var configuration = DefaultRendererConfiguration()
        configuration.resourceLinkBlockViewProvider = ExampleBlockViewProvider()
        configuration.resourceLinkInlineStringProvider = ExampleInlineStringProvider()
        configuration.textConfiguration = .default
        
        let renderersProvider = DefaultRenderersProvider()
        let renderer = RichTextDocumentRenderer(
            configuration: configuration,
            nodeRenderers: renderersProvider
        )
        
        super.init(renderer: renderer, heightObservable: heightObservable, isScrollEnabled: isScrollEnabled)
        
        self.content = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.richTextDocument = content
    }
}

private struct ExampleBlockViewProvider: ResourceLinkBlockViewProviding {
    func view(for resource: Contentful.Link, context: [CodingUserInfoKey: Any]) -> ResourceLinkBlockViewRepresentable? {
        switch resource {
        case .entryDecodable(let entryDecodable):
            
            switch entryDecodable {
            case let image as RichImage:
                return ArticleCustomView(image: image)
                
            case let author as Author:
                return AuthorViewExample(author: author)
                
            case let socialMediaPost as SocialMediaPost:
                if let url = URL(string: socialMediaPost.url ?? "") {
                    return SocialMediaPreview(url: url)
                }
                
            default: return nil
            }
            
        case .entry:
             return nil
            
        case .asset(let asset):
            guard asset.file?.details?.imageInfo != nil else { return nil }
            
            let imageView = ResourceLinkBlockImageView(asset: asset)
            
            imageView.backgroundColor = UIColor.secondaryLabel
            imageView.setImageToNaturalHeight()
            return imageView
            
        default:
            return nil
        }
        return nil
    }
}

private struct ExampleInlineStringProvider: ResourceLinkInlineStringProviding {
    func string(
        for resource: Contentful.Link,
        context: [CodingUserInfoKey : Any]
    ) -> NSMutableAttributedString {
        switch resource {
        case .entryDecodable(let entryDecodable):
            if let cat = entryDecodable as? Author {
                return AuthorInlineProvider.string(for: cat)
            }
            
        default:
            break
        }
        
        return NSMutableAttributedString(string: "")
    }
}

private struct AuthorInlineProvider {
    static func string(for author: Author) -> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: "\(String(describing: author.name))",
            attributes: [
                .foregroundColor: UIColor.label
            ]
        )
    }
}
