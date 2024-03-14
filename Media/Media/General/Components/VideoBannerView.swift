//
//  VideoBannerView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct VideoBannerView: View {
    var router: any Router
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
                
                HStack {
                    switch model.dataLink?.item {
                    case let article as Article:
                        CTAButton(title: model.ctaText ?? "") {
                            router.push(article)
                        }
                        //...
                    default:
                        EmptyView()
                    }
                    Spacer()
                }
                .padding(.leading, .small)
            }
            .padding()
            .background(model.backgroundColor != nil ? Color(hex: model.backgroundColor ?? "") : Color(.systemBackground))
        }
    }
}
