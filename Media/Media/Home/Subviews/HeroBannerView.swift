//
//  HeroBannerView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct HeroBannerView: View {
    var model: HeroBanner
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Image
                AsyncImageView(url: model.image?.url)
                
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
                if let article = model.targetPage?.item as? Article {
                    
                    NavigationLink(value: article, label: {
                        HStack(spacing: 8) {
                            Text(model.ctaText ?? "")
                            Image(systemName: "arrow.right.circle")
                                .imageScale(.large)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Capsule()
                            .strokeBorder(.white, lineWidth: 1.3))
                    })
                    .foregroundStyle(.white)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color(hex: model.backgroundColor ?? ""))
    }
}
