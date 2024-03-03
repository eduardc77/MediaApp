//
//  AppScreen.swift
//  MediaApp
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case news
    case videos
    case menu
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house")
        case .news:
            Label("News", systemImage: "newspaper")
        case .videos:
            Label("Videos", systemImage: "video.and.waveform.fill")
        case .menu:
            Label("Menu", systemImage: "line.3.horizontal")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeCoordinator()
        case .news:
            NewsCoordinator()
        case .videos:
            VideosCoordinator()
        case .menu:
            MenuCoordinator()
        }
    }
}
