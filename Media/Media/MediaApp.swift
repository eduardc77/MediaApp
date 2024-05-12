//
//  MediaApp.swift
//  Media
//

import SwiftUI

@main
struct MediaApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(settings.theme.color)
                .environmentObject(settings)
                .preferredColorScheme(settings.displayAppearance.colorScheme)
        }
    }
}
