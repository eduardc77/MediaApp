//
//  HomeCoordinator.swift
//  MediaApp
//

import SwiftUI
import MediaContentful

struct HomeCoordinator: View {
    @State private var homeNavigationPath = NavigationPath()
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        NavigationStack(path: $homeNavigationPath) {
            HomeView(homePath: $homeNavigationPath)
                .navigationDestination(for: Article.self) { article in
                    ArticleView(articleId: article.id)
                }
        }
    }
}

struct HomeCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        HomeCoordinator()
            .environmentObject(AppTabCoordinator())
            .environmentObject(ModalScreenRouter())
    }
}
