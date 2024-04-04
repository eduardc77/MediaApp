//
//  NewsCoordinator.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaNetwork

struct NewsCoordinator: View {
    @StateObject private var router = NewsViewRouter()
    @EnvironmentObject private var tabRouter: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            NewsView()
                .navigationDestination(for: AnyHashable.self) { destination in
                    switch destination {
                    case let newsArticle as NewsArticle:
                        MediaWebView(urlString: newsArticle.url ?? "")
                            .navigationTitle(newsArticle.source?.name ?? "")
                            .navigationBarTitleDisplayMode(.inline)
                    default:
                        EmptyView()
                    }
                }
                .onReceive(tabRouter.$tabReselected) { tabReselected in
                    guard tabReselected, tabRouter.selection == .news, !router.path.isEmpty else { return }
                    router.popToRoot()
                }
                .environmentObject(router)
        }
    }
}

enum NewsDestination: Hashable {
    case articleWebView(newsArticle: NewsArticle)
}

#Preview {
    NewsCoordinator()
}
