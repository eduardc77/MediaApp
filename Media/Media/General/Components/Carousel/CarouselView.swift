//
//  SmallCarouselView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaContentful

struct CarouselView: View {
    var router: any Router
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
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    switch items {
                    case let articles as [Article]:
                        ForEach(articles, id: \.id) { article in
                            Button {
                                router.push(article)
                            } label: {
                                ArticleSmallGridItem(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                        //...
                        
                    default: EmptyView()
                    }
                }
                .padding()
            }
        } header: {
            Text(model.title ?? "")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.leading)
        }
    }
    
    @ViewBuilder
    func mediumCarouselView(with items: [GroupItem]) -> some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    switch items {
                    case let articles as [Article]:
                        ForEach(articles, id: \.id) { article in
                            Button {
                                router.push(article)
                            } label: {
                                ArticleMediumGridItem(article: article)
                            }
                            .buttonStyle(.plain)
                        }
                        //...
                        
                    default: EmptyView()
                    }
                }
                .padding()
            }
        } header: {
            Text(model.title ?? "")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.leading)
        }
    }
    
    @ViewBuilder
    func largeCarouselView(with items: [GroupItem]) -> some View {
        switch items {
        case let articles as [Article]:
            TabView {
                ForEach(articles, id: \.id) { article in
                    Button {
                        router.push(article)
                    } label: {
                        ArticleLargeGridItem(article: article)
                    }
                    .buttonStyle(.plain)
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

