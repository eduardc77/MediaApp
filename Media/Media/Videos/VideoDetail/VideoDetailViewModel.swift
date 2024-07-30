//
//  VideoDetailViewModel.swift
//  MediaApp
//

import Foundation
import MediaNetwork

final class VideoDetailViewModel: BaseViewModel<ViewState> {
    let videosService: VideosServiceable
    
    @Published private(set) var videoDetail: Video?
    @Published private(set) var casts: CastModel?
    
    private let environment = Videos.Environment.develop(apiKey: DemoAPIKeys.theMovieDB)
    
    private let id: Int?
    
    init(videosService: VideosServiceable, id: Int?) {
        self.videosService = videosService
        self.id = id
        super.init()
    }

    @MainActor
    func fetchDetails() async {
        guard let id = id else { return }
        self.changeState(.loading)
        
        do {
            let result: Video = try await videosService.getVideo(id: id)
            self.videoDetail = result
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
    
    @MainActor
    func fetchCast() async {
        guard let id = id else { return }
        
        do {
            let result: CastModel = try await videosService.getVideoCredits(id: id)
            self.casts = result
            self.changeState(.finished)
        } catch {
            self.changeState(.error(error: error.localizedDescription))
        }
    }
}
