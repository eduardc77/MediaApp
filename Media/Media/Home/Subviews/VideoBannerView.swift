//
//  VideoBannerView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct VideoBannerView: View {
    var model: VideoBanner
    
    var body: some View {
        if let urlString = model.featuredVideoURL, let videoURL = URL(string: urlString) {
            VStack {
                VStack(spacing: .medium3) {
                    SocialMediaPreviewRepresentable(url: videoURL)
                        .frame(height: 250)
                    
                    Text(model.headline ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
                
                if let article = model.dataLink?.item as? Article {
                    HStack {
                        NavigationLink(value: article, label: {
                            Text(model.ctaText ?? "").fontWeight(.semibold)
                                .padding(2)
                        })
                        .controlSize(.small)
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                    }
                    .padding(.leading, .small)
                }
            }
            .padding()
            .background(model.backgroundColor != nil ? Color(hex: model.backgroundColor ?? "") : Color(.systemBackground))
        }
    }
}
