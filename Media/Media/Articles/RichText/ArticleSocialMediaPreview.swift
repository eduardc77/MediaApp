//
//  ArticleSocialMediaPreview.swift
//  MediaApp
//

import SwiftUI
import LinkPresentation
import MediaContentful

class SocialMediaPreview: UIView, ResourceLinkBlockViewRepresentable {
    private let url: URL
    private var linkView: LPLinkView
    
    let dataProvider = LPMetadataProvider()
    var context: [CodingUserInfoKey : Any] = [:]
    
    public init(url: URL) {
        self.url = url
        linkView = LPLinkView(url: url)
        
        super.init(frame: .init(x: 0, y: 0, width: 1, height: 1))
        
        addSubview(linkView)
        
        linkView.topAnchor.constraint(
            equalTo: topAnchor
        ).isActive = true
        
        linkView.bottomAnchor.constraint(
            equalTo: bottomAnchor
        ).isActive = true
        
        linkView.leadingAnchor.constraint(
            equalTo: leadingAnchor
        ).isActive = true
        
        linkView.trailingAnchor.constraint(
            equalTo: trailingAnchor
        ).isActive = true
        linkView.translatesAutoresizingMaskIntoConstraints = false
        
        dataProvider.startFetchingMetadata(for: url) { [weak self] (metaData, error) in
            if let metaData = metaData {
                DispatchQueue.main.async {
                    self?.linkView.metadata = metaData
                    self?.linkView.sizeToFit()
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(with width: CGFloat) {
        layoutIfNeeded()
    }
}

struct SocialMediaPreviewRepresentable: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> SocialMediaPreview {
        SocialMediaPreview(url: url)
    }
    
    func updateUIView(_ uiView: SocialMediaPreview, context: Context) {}
}
