//
//  HeroBannerView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct HeroBannerView: View {
    var router: any Router
    var model: HeroBanner
    
    var body: some View {
        VStack(spacing: 20) {
            // Image
            if let imageURL = model.image?.url {
                AsyncImageView(url: imageURL)
            } else {
                Color.secondary
            }
            
            // Text
            Group {
                Text(model.headline ?? "")
                    .font(.title)
                    .fontWeight(.heavy)
                    .shadow(radius: 2, x: 2, y: 2)
                
                Text(model.subheadline ?? "")
                    .font(.headline)
            }
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .padding(.horizontal)
            
            // Button
            switch model.targetPage?.item {
            case let article as Article:
                CTAButton(title: model.ctaText ?? "") {
                    router.push(article)
                }
                //...
            default:
                EmptyView()
            }
        }
        .padding(.bottom, 20)
        .background(Color(hex: model.backgroundColor ?? ""))
    }
}
