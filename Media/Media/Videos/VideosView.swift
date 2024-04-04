//
//  VideosView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaNetwork

struct VideosView: View {
    @StateObject private var viewModel = VideosViewModel()
    @EnvironmentObject private var router: VideoViewRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter

    @State private var isLoading: Bool = false
    
    var body: some View {
        baseView
            .navigationBar(title: "Videos")
            .searchable(text: $viewModel.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search")
            .onChange(of: viewModel.searchQuery) { query in
                guard !query.isEmpty else { return }
                viewModel.newSearchPerformed = true
                
                Task {
                    await viewModel.search(with: query)
                    viewModel.newSearchPerformed = false
                }
            }
    }
    
    @ViewBuilder
    private var baseView: some View {
        switch viewModel.state {
        case .empty:
            Label("No Data", systemImage: "newspaper")
        case .finished:
            ScrollViewReader { scrollProxy in
                ScrollView {
                    videosGrid
                }
                .onChange(of: viewModel.searchQuery) { newValue in
                    scrollProxy.scrollTo(0)
                }
            }
            
        case .loading:
            ProgressView("Loading")
        case .error(error: let error):
            VStack {
                Label("Error", systemImage: "alert")
                Text(error)
            }
            .onAppear {
                modalRouter.presentAlert(title: "Error", message: error) {
                    Button("Ok") {
                        viewModel.changeStateToEmpty()
                    }
                }
            }
        case .initial:
            ProgressView()
                .onFirstAppear {
                    Task {
                        isLoading = true
                        await viewModel.fetchDiscoverData()
                        isLoading = false
                    }
                }
        }
    }
}

// MARK: - Subviews

private extension VideosView {
    
    var videosGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(Array(viewModel.videos.enumerated()), id: \.offset) { index, video in
                gridItem(for: video)
                    .id(index)
            }
            
            Rectangle()
                .fill(.clear)
                .frame(height: 20) // Bottom padding
                .onAppear {
                    if !isLoading, !viewModel.videos.isEmpty {
                        isLoading = true
                        
                        Task {
                            await viewModel.loadMoreContent()
                            isLoading = false
                        }
                    }
                }
        }
        .padding(.horizontal, 10)
        
    }
    
    func gridItem(for video: Video) -> some View {
        NavigationButton {
            router.push(VideoDestination.videoDetail(id: video.id))
        } label: {
            VideoGridItem(item: VideoItem(imageUrl: video.posterUrl(width: 200),
                                          title: video.title,
                                          date: video.releaseDate ?? ""))
        }
    }
}

#Preview {
    VideosView()
        .environmentObject(ModalScreenRouter())
}

