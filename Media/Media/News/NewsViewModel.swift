//
//  NewsViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class NewsViewModel: BaseViewModel<ViewState> {
    typealias Environment = NewsService.Environment
    typealias Route = NewsService.Route
    
    @Published private(set) var allNews = [NewsArticle]()
    
    var selectedCategory: NewsCategory
    
    init(selectedCategory: NewsCategory) {
        self.selectedCategory = selectedCategory
    }

    @MainActor
    func fetchNews() async {
        guard state != .empty else { return }
        changeState(.loading)
        
        do {
            let result: NewsServiceModel = try await URLSession.shared.fetchItem(
                at: selectedCategory == .all ? Route.allNews(country: .us) : Route.newsByCategory(category: selectedCategory.title, country: .us),
                in: Environment.develop)
            
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
