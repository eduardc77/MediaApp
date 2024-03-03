//
//  SmallCarouselView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct CarouselView: View {
    var model: Carousel
    
    var body: some View {
        if let items = model.groupData?.items, !items.isEmpty {
            switch model.size {
            case .small:
                smallCarouselView(with: items)
            case .medium:
                mediumCarouselView(with: items)
            case .large:
                largeCarouselView(with: items)
            default: 
                EmptyView()
            }
        }
    }
}

// MARK: - Subviews

private extension CarouselView {
    
    @ViewBuilder
    func smallCarouselView(with items: [GroupItem]) -> some View {
        switch items {
        case let articles as [Article]:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(articles, id: \.id) { article in
                        ArticleSmallGridItem(article: article)
                    }
                }
                .padding()
            }
        default: EmptyView()
        }
        
        
    }
    
    @ViewBuilder
    func mediumCarouselView(with items: [GroupItem]) -> some View {
        switch items {
        case let articles as [Article]:
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(articles, id: \.id) { article in
                        ArticleMediumGridItem(article: article)
                    }
                }
                .padding()
            }
            
            //...
            
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func largeCarouselView(with items: [GroupItem]) -> some View {
        switch items {
        case let articles as [Article]:
            TabView {
                ForEach(articles, id: \.id) { article in
                    ArticleLargeGridItem(article: article)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 400)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.secondaryLabel
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.tertiaryLabel
            }
            
            //...
            
        default: EmptyView()
        }
    }
}

