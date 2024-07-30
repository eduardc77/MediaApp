//
//  VideosGrid.swift
//  Media
//

import SwiftUI
import MediaUI
import MediaNetwork

struct VideosGrid: View {
    var router: any Router
    @ObservedObject var model: VideosViewModel
    var width: Double
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
#endif
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    var useReducedThumbnailSize: Bool {
#if os(iOS)
        if sizeClass == .compact {
            return true
        }
#endif
        if dynamicTypeSize >= .xxxLarge {
            return true
        }
        
#if os(iOS)
        if width <= 390 {
            return true
        }
#elseif os(macOS)
        if width <= 520 {
            return true
        }
#endif
        
        return false
    }
    
    var cellSize: Double {
        useReducedThumbnailSize ? 150 : 200
    }
    
    var thumbnailSize: Double {
#if os(iOS)
        return useReducedThumbnailSize ? 60 : 100
#else
        return useReducedThumbnailSize ? 40 : 80
#endif
    }
    
    var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum: cellSize), spacing: 20, alignment: .top)]
    }
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            ForEach(model.videos, id: \.self) { video in
                gridItem(for: video)
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
        .padding()
    }
    
    func gridItem(for video: Video) -> some View {
        NavigationButton {
            router.push(VideoDestination.videoDetail(id: video.id))
        } label: {
            VideoGridItem(item: VideoItem(imageURL: video.posterURL(width: 200),
                                          title: video.title,
                                          date: video.releaseDate ?? ""))
        }
    }
}
