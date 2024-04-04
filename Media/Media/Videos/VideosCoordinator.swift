//
//  VideosCoordinator.swift
//  MediaApp
//

import SwiftUI

struct VideosCoordinator: View {
    @StateObject private var router = VideoViewRouter()
    @EnvironmentObject private var tabRouter: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    @State private var isWebViewLoading = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VideosView()
                .navigationDestination(for: AnyHashable.self) { destination in
                    switch destination {
                    case .videoDetail(let id) as VideoDestination:
                        VideoDetailView(id: id)
                    default:
                        EmptyView()
                    }
                }
                .onReceive(tabRouter.$tabReselected) { tabReselected in
                    guard tabReselected, tabRouter.selection == .videos, !router.path.isEmpty else { return }
                    router.popToRoot()
                }
                .environmentObject(router)
        }
    }
}

enum VideoDestination: Hashable {
    case videoDetail(id: Int)
}

struct VideosCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        VideosCoordinator()
            .environmentObject(AppTabRouter())
    }
}
