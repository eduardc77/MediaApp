//
//  VideosViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class VideosViewModel: BaseViewModel<ViewState> {
    let videosService: VideosServiceable
    
    @Published private(set) var videoPaginationResult: VideoPaginationResult?
    @Published private(set) var discoverMovies = [Video]()
    @Published private(set) var searchMovies = [Video]()
    
    @Published var searchQuery = ""
    @Published var newSearchPerformed = false
    
    @Published var movieList: MovieList = .discover {
        willSet {
            discoverMovies.removeAll()
            
            Task {
                await fetchDiscoverData()
            }
        }
    }
    
    var route: Videos.Route {
        switch movieList {
        case .discover:
            Videos.Route.discoverMovies(page: currentPage)
        case .nowPlaying:
            Videos.Route.nowPlaying(page: currentPage)
        case .popular:
            Videos.Route.popular(page: currentPage)
        case .topRated:
            Videos.Route.topRated(page: currentPage)
        case .upcoming:
            Videos.Route.upcoming(page: currentPage)
        }
    }
    
    @Published private var isLoading: Bool = false
    
    let environment = Videos.Environment.develop(apiKey: DemoAPIKeys.theMovieDB)
    
    var videos: [Video] {
        searchMovies.isEmpty ? discoverMovies : searchMovies
    }
    
    var currentPage: Int {
        if newSearchPerformed {
            return 1
        } else {
            return (videoPaginationResult?.page ?? 0) + 1
        }
    }
    
    var isSearching: Bool {
        !searchQuery.isEmpty
    }
    
    func changeStateToEmpty() {
        changeState(.empty)
    }
    
    //Use dependency injection not assigning in the initializer
    init(videosService: VideosServiceable = VideosService()) { // VideosServiceMock()
        self.videosService = videosService
    }
    
    @MainActor
    func fetchDiscoverData() async {
        guard state != .empty else { return }
        if currentPage == 1 || discoverMovies.isEmpty {
            self.changeState(.loading)
        }
        do {
            let result: VideoPaginationResult = try await videosService.getVideos(for: route)
            self.updateDiscoverResult(with: result)
            self.videoPaginationResult = result
            self.changeState(.finished)
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
    
    @MainActor
    func search(with query: String) async {
        do {
            let result: VideoPaginationResult = try await videosService.searchVideos(query: query, page: currentPage)
            self.updateSearchResult(with: result)
            self.videoPaginationResult = result
            
            if !searchQuery.isEmpty, result.totalResults == 0 {
                self.changeStateToEmpty()
            } else if state != .finished {
                self.changeState(.finished)
            }
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
    
    func loadMoreContent() async {
        guard currentPage != videoPaginationResult?.totalPages else { return }
        if !isSearching {
            await fetchDiscoverData()
        } else {
            await search(with: searchQuery)
        }
    }
    
    private func updateDiscoverResult(with result: VideoPaginationResult) {
        discoverMovies += result.results
    }
    
    private func updateSearchResult(with result: VideoPaginationResult) {
        guard !searchQuery.isEmpty else { return }
        if newSearchPerformed {
            searchMovies = result.results
            newSearchPerformed = false
        } else {
            searchMovies += result.results
        }
    }
}

enum MovieList {
    case discover, nowPlaying, popular, topRated, upcoming
}
