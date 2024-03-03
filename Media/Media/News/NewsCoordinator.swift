//
//  NewsCoordinator.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaNetwork

struct NewsCoordinator: View {
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    @State private var newsNavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $newsNavigationPath) {
            NewsView(newsPath: $newsNavigationPath)
                .navigationDestination(for: NewsArticle.self) { newsArticle in
                    MediaWebView(urlString: newsArticle.url ?? "")
                        .navigationTitle(newsArticle.source?.name ?? "")
                        .navigationBarTitleDisplayMode(.inline)
                }
        }
    }
}

enum NewsDestination: Hashable {
    case articleWebView(newsArticle: NewsArticle)
}

//#Preview {
//    NewsCoordinator()
//}
