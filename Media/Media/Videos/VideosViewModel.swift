//
//  VideosViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class VideosViewModel: BaseViewModel<ViewState> {
    typealias Environment = VideosService.Environment
    typealias Route = VideosService.Route
    
    @Published private(set) var videoPaginationResult: VideoPaginationResult?
    @Published private(set) var discoverMovies = [Video]()
    @Published private(set) var searchMovies = [Video]()
    
    @Published var searchQuery = ""
    @Published var newSearchPerformed = false
    
    private let session = URLSession.shared
    let environment = Environment.production(apiKey: DemoAPIKeys.theMovieDB)
    
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
    
    @MainActor
    func fetchDiscoverData() async {
        guard state != .empty else { return }
        if currentPage == 1 {
            self.changeState(.loading)
        }
        do {
            let result: VideoPaginationResult = try await session.fetchItem(
                at: Route.discoverMovies(page: currentPage),
                in: environment
            )
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
            let result: VideoPaginationResult = try await session.fetchItem(
                at: Route.searchMovies(query: query, page: currentPage),
                in: environment
            )
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
