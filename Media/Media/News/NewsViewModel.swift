//
//  NewsViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class NewsViewModel: BaseViewModel<ViewState> {
    let newsService: NewsServiceable
    
    @Published private(set) var allNews = [NewsArticle]()
    
    var selectedCategory: NewsCategory
    
    //Use dependency injection not assigning in the initializer
    init(newsService: NewsServiceable = NewsService(), selectedCategory: NewsCategory) { // NewsServiceMock()
        self.newsService = newsService
        self.selectedCategory = selectedCategory
    }

    @MainActor
    func fetchNews() async {
        guard state != .empty else { return }
        changeState(.loading)
        
        do {
            let result: NewsServiceModel = try await newsService.getNews(for: selectedCategory == .all ? News.Route.allNews(country: .us) : News.Route.newsByCategory(category: selectedCategory.title, country: .us))
            self.changeState(.finished)
            self.allNews = result.articles ?? []
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
    
    func changeStateToEmpty() {
        changeState(.empty)
    }
    
}

struct NewsServiceModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [NewsArticle]?
}
