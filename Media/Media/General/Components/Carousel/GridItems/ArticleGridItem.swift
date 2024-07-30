//
//  ArticleGridItem.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct ArticleSmallGridItem: View {
    var article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = article.featuredImage?.url {
                AsyncImageView(url: imageURL, size: .custom(width: 160, height: 100))
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.secondary.opacity(0.2), lineWidth: 0.8))
            } else {
                Color.secondary.frame(width: 160, height: 100)
            }
            
            Text(article.title)
                .font(Font.footnote)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(width: 160)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct ArticleMediumGridItem: View {
    var article: Article
    var isCarouselItem: Bool = true
    var backgroundColor: Color = Color(.systemGray6)
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = article.featuredImage?.url {
                AsyncImageView(url: imageURL, size: .custom(height: 200))
                    .clipped()
            } else {
                Color.secondary
                    .frame(height: 200)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title)
                    .lineLimit(2)
                    .font(Font.title3.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(article.subtitle ?? "")
                    .lineLimit(3)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .background(backgroundColor)
        .frame(maxWidth: isCarouselItem ? UIScreen.main.bounds.width - 60 : .infinity, idealHeight: 340)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.secondary.opacity(0.2), lineWidth: 0.8))
    }
}

struct ArticleLargeGridItem: View {
    var article: Article
    
    var body: some View {
        GeometryReader { geometry in
            if let imageURL = article.featuredImage?.url {
                AsyncImageView(url: imageURL, size: .custom(width: geometry.size.width, height: 400))
                    .clipped()
                    .buttonStyle(.plain)
            }
        }
    }
}
