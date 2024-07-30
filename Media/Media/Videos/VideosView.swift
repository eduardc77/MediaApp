//
//  VideosView.swift
//  MediaApp
//

import SwiftUI
import MediaUI
import MediaNetwork

struct VideosView: View {
    @ObservedObject var model: VideosViewModel
    
    @EnvironmentObject private var router: VideoViewRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    @State private var layout = BrowserLayout.grid
    
    var body: some View {
        baseView
            .toolbar {
                ToolbarItemGroup {
                    toolbarItems
                }
            }
            .searchable(text: $model.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search")
            .searchSuggestions {
                if model.searchQuery.isEmpty {
                    searchSuggestions
                }
            }
            .onChange(of: model.searchQuery) { query in
                guard !query.isEmpty else { return }
                model.newSearchPerformed = true
                
                Task {
                    await model.search(with: query)
                    model.newSearchPerformed = false
                }
            }
    }
    
    @ViewBuilder
    private var baseView: some View {
        switch model.state {
        case .empty:
            Label("No Data", systemImage: "newspaper")
        case .finished:
            Group {
                switch layout {
                case .grid:
                    grid
                case .list:
                    list
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
                        model.changeStateToEmpty()
                    }
                }
            }
        case .initial:
            ProgressView()
                .onFirstAppear {
                    Task {
                        await model.fetchDiscoverData()
                    }
                }
        }
    }
}

// MARK: - Subviews

private extension VideosView {
    
    var grid: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                VideosGrid(router: router, model: model, width: geometryProxy.size.width)
            }
        }
    }
    
    var list: some View {
        List {
            ForEach(model.discoverMovies) { video in
                listRow(for: video)
            }
            
            Rectangle()
                .fill(.clear)
                .frame(height: 20) // Bottom padding
                .task {
                    if model.state != .loading, !model.videos.isEmpty {
                        await model.loadMoreContent()
                    }
                }
        }
        .listStyle(.plain)
    }
    
    func listRow(for video: Video) -> some View {
        NavigationButton {
            router.push(VideoDestination.videoDetail(id: video.id))
        } label: {
            VideoRow(item: VideoItem(imageURL: video.posterURL(width: 200),
                                     title: video.title,
                                     date: video.releaseDate ?? ""))
        }
    }
    
    @ViewBuilder
    var toolbarItems: some View {
        Menu {
            Picker("Layout", selection: $layout) {
                ForEach(BrowserLayout.allCases) { option in
                    Label(option.title, systemImage: option.imageName)
                        .tag(option)
                }
            }
            .pickerStyle(.inline)
            
            Picker("Movie List", selection: $model.movieList) {
                Label("Discover", systemImage: "wand.and.stars")
                    .tag(MovieList.discover)
                Label("Now Playing", systemImage: "play.square.stack")
                    .tag(MovieList.nowPlaying)
                Label("Popular", systemImage: "party.popper")
                    .tag(MovieList.popular)
                Label("Top Rated", systemImage: "star")
                    .tag(MovieList.topRated)
                Label("Upcoming", systemImage: "hourglass.start")
                    .tag(MovieList.upcoming)
            }
            .pickerStyle(.inline)
            
        } label: {
            Label("Layout Options", systemImage: layout.imageName)
                .labelStyle(.iconOnly)
        }
    }
    
    var searchSuggestions: some View {
        ForEach(model.searchMovies.prefix(10)) { movie in
            Text("**\(movie.title)**")
                .searchCompletion(movie.title)
        }
    }
}

#Preview {
    VideosView(model: VideosViewModel(videosService: VideosServiceMock()))
        .environmentObject(ModalScreenRouter())
}

