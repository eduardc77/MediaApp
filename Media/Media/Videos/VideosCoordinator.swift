//
//  VideosCoordinator.swift
//  MediaApp
//

import SwiftUI

struct VideosCoordinator: View {
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    @State private var menuNavigationPath = NavigationPath()
    @State private var isWebViewLoading = false
    
    var body: some View {
        NavigationStack(path: $menuNavigationPath) {
            VideosView(path: $menuNavigationPath)
                .navigationDestination(for: VideoDestination.self) { destination in
                    switch destination {
                    case .videoDetail(let id):
                        VideoDetailView(id: id)
                    }
                }
        }
    }
}

enum VideoDestination: Hashable {
    case videoDetail(id: Int)
}

struct VideosCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        VideosCoordinator()
            .environmentObject(AppTabCoordinator())
    }
}
