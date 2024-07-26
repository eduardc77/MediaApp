//
//  ArticleView.swift
//  BlogAppSwiftUI
//

import SwiftUI
import MediaUI
import MediaContentful

struct ArticleView: View {
    @StateObject private var model: ArticleViewModel
    @StateObject private var heightObservable = RichTextHeightObservable()
    
    @Namespace private var scrollSpace
    
    init(articleId: String) {
        _model = StateObject(wrappedValue: ArticleViewModel(id: articleId))
    }
    
    var body: some View {
        if let article = model.article {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Article Header Image
                    articlePreviewHeader(article.featuredImage?.url)
                    
                    VStack(alignment: .leading) {
                        // Article Title and Caption
                        articlePreviewTitleView(article: article)
                        // Article Body
                        if let richText = article.body?.richText {
                            ArticleViewControllerRepresentable(content: richText, heightObservable: heightObservable)
                                .frame(height: heightObservable.height)
                        }
                    }
                    .padding(.bottom)
                    .background()
                    
                    // Article Footer
                    if let relatedArticles = article.relatedArticles?.groupData?.items as? [Article] {
                        relatedArticlesFooterView(relatedArticles)
                    }
                }
            }
            .background(model.article?.hasRelatedArticles ?? false ? Color(.systemGray6) : Color(.systemBackground))
            .coordinateSpace(name: scrollSpace)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .top)
        } else {
            ProgressView()
        }
    }
}

// MARK: - Subviews

private extension ArticleView {
    
    func articlePreviewHeader(_ featuredImageURL: URL?) -> some View {
        ParallaxHeaderView(
            coordinateSpace: scrollSpace,
            height: Metric.mediaPreviewHeaderHeight
        ) {
            if let imageUrl = featuredImageURL{
                AsyncImageView(url: imageUrl)
            } else {
                Color.secondary
            }
        }
    }
    
    func articlePreviewTitleView(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(article.title)
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
                .padding(.top, 10)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Published")
                    
                    if let publishedDate = article.publishedDate {
                        Text(publishedDate, format: .dateTime.day().month().year())
                    }
                }
                .font(.footnote.weight(.medium))
                .foregroundColor(Color.secondary)
                .lineLimit(1)
                
                Spacer()
                if let author = article.author {
                    HStack {
                        if let authorImage = author.avatar?.url {
                            AsyncImageView(url: authorImage, size: .xxSmall)
                        }
                        Text(author.name ?? "")
                            .font(.footnote.weight(.medium))
                    }
                }
            }
            Divider()
        }
        .padding(.horizontal)
    }
    
    func relatedArticlesFooterView(_ relatedArticles: [Article]) -> some View {
        VStack(alignment: .leading) {
            Text("Related Articles")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2.bold())
                .padding(.leading, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(relatedArticles, id: \.id) { article in
                        NavigationLink(destination: ArticleView(articleId: article.id)) {
                            ArticleMediumGridItem(article: article, backgroundColor: Color(UIColor.tertiarySystemBackground))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ArticleView(articleId: "58AAxmghXsVANmbwp9CClk")      .frame(height: 800)
}
