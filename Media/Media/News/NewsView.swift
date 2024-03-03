//
//  NewsView.swift
//  MediaApp
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var tabCoordinator: AppTabCoordinator
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    @StateObject private var viewModel = NewsViewModel()
    @Binding var newsPath: NavigationPath
    
    var body: some View {
        baseView()
            .navigationBar(title: "News")
            .onReceive(tabCoordinator.$tabReselected) { tabReselected in
                guard tabReselected, tabCoordinator.selection == .news, !newsPath.isEmpty else { return }
                newsPath.removeLast(newsPath.count)
            }
            .refreshable {
                Task {
                    await viewModel.fetchNews()
                }
            }
    }
    
    @ViewBuilder
    private func baseView() -> some View {
        switch viewModel.state {
        case .empty:
            Label("No Data", systemImage: "newspaper")
        case .finished:
            ScrollView {
                newsGrid
            }
        case .loading:
            ProgressView("Loading")
        case .error(error: let error):
            VStack {
                Label("Error", systemImage: "alert")
                Text(error)
            }
            .onFirstAppear {
                modalRouter.presentAlert(title: "Error", message: error) {
                    Button("Ok") {
                        viewModel.changeStateToEmpty()
                    }
                }
            }
        case .initial:
            ProgressView()
                .onAppear {
                    Task {
                        await viewModel.fetchNews()
                    }
                }
        }
    }
}

// MARK: - Subviews

private extension NewsView {
    
    var newsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(Array(viewModel.allNews.enumerated()), id: \.offset) { index, article in
                Button {
                    newsPath.append(article)
                } label: {
                    NewsGridItem(item: NewsItem(imageUrl: article.urlToImage ?? "",
                                                owner: article.source?.name ?? "",
                                                title: article.title ?? "",
                                                date:  article.publishedAt?.timestampString() ?? ""))
                }
            }
        }
        .padding(10)
    }
}

//#Preview {
//    NavigationStack {
//        NewsView()
//    }
//}
