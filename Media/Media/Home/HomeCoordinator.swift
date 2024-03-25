//
//  HomeCoordinator.swift
//  MediaApp
//

import SwiftUI
import MediaContentful

struct HomeCoordinator: View {
    @StateObject private var router = HomeViewRouter()
    @EnvironmentObject private var tabRouter: AppTabRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AnyHashable.self) { destination in
                    switch destination {
                    case let article as Article:
                        ArticleView(articleId: article.id)
                    default:
                        EmptyView()
                    }
                }
                .onReceive(tabRouter.$tabReselected) { tabReselected in
                    guard tabReselected, tabRouter.selection == .home, !router.path.isEmpty else { return }
                    router.popToRoot()
                }
                .environmentObject(router)
        }
    }
}

#Preview {
    HomeCoordinator()
        .environmentObject(AppTabRouter())
        .environmentObject(ModalScreenRouter())
}
