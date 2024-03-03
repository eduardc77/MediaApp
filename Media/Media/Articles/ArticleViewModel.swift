//
//  ArticleViewModel.swift
//  MediaApp
//

import Foundation
import Contentful
import MediaContentful

final class ArticleViewModel: ObservableObject {
    @Published var article: Article?
    @Published var isLoading: Bool = false
    
    private let contentful = ContentfulService.shared.contentful
    private weak var articleRequest: URLSessionTask?
    
    init(id: String) {
        fetchArticle(id: id)
    }
    
    func fetchArticle(id: String) {
        isLoading = true
        articleRequest?.cancel()
        
        articleRequest = contentful.client.fetch(Article.self, id: id, include: 3) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let article):
                    guard let articleBody = article.body,
                          articleBody.richText != nil else {
                        print("Article body is missing.")
                        return
                    }
                    self.article = article
                    self.isLoading = false
                    
                case .failure(let error):
                    print(error)
                    self.isLoading = false
                }
            }
        }
    }
}

