//
//  VideoDetailViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class VideoDetailViewModel: BaseViewModel<ViewState> {
    typealias Environment = VideosService.Environment
    typealias Route = VideosService.Route
    
    @Published private(set) var videoDetail: Video?
    @Published private(set) var casts: CastModel?
    
    private let session = URLSession.shared
    private let environment = Environment.develop(apiKey: DemoAPIKeys.theMovieDB)
    
    private let id: Int?
    
    init(id: Int?) {
        self.id = id
        super.init()
    }
    
    @MainActor
    func fetchDetails() async {
        guard let id = id else { return }
        self.changeState(.loading)
        
        do {
            let result: Video = try await session.fetchItem(
                at: Route.movie(id: id),
                in: environment
            )
            self.videoDetail = result
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
    
    @MainActor
    func fetchCast() async {
        guard let id = id else { return }
        
        do {
            let result: CastModel = try await session.fetchItem(
                at: Route.movieCredits(id: id),
                in: environment
            )
            self.casts = result
            self.changeState(.finished)
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
}
