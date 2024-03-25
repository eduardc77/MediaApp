//
//  AppTabView.swift
//  MediaApp
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var tabRouter = AppTabRouter()
    @StateObject private var modalRouter = ModalScreenRouter()
    @Environment(\.openURL) var openURL
    
    var body: some View {
        TabView(selection: $tabRouter.selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
        .sheet(item: $modalRouter.presentedSheet, content: sheetContent)
        .fullScreenCover(item: $modalRouter.presentedFullScreenCover, content: fullScreenCoverContent)
        .popover(item: $modalRouter.presentedPopover.content,
                 attachmentAnchor: modalRouter.presentedPopover.attachmentAnchor,
                 arrowEdge: modalRouter.presentedPopover.arrowEdge,
                 content: popoverContent)
        .alert($modalRouter.alert)
        .environmentObject(tabRouter)
        .environmentObject(modalRouter)
        .onOpenURL { url in
            
        }
        .onReceive(tabRouter.$urlString) { newValue in
            guard let urlString = newValue, let url = URL(string: urlString) else { return }
            openURL(url)
        }
    }
    
    @ViewBuilder
    private func sheetContent(_ content: AnyIdentifiable) -> some View {
        if let destination = content.destination as? NavigationBarSheetDestination {
            switch destination {
            case .account(profile: let profile):
                AccountDetailView(profile: profile)
            case .share:
                Text("Share")
            }
        } else if let destination = content.destination as? MenuSheetDestination {
            switch destination {
            case .menuWebViewSheet(urlString: let urlString):
                MenuWebView(urlString: urlString)
            }
        }
    }
    
    @ViewBuilder
    private func fullScreenCoverContent(_ content: AnyIdentifiable) -> some View {
        if let destination = content.destination as? NavigationBarFullScreenCoverDestination {
            switch destination {
            case .search:
                SearchCoordinator()
            }
        } else if let destination = content.destination as? MenuFullScreenCoverDestination {
            switch destination {
            case .menuWebViewFullScreenCover(urlString: let urlString):
                NavigationStack {
                    MenuWebView(urlString: urlString, hasCloseButton: true)
                }
            }
        }
    }
    
    @ViewBuilder
    private func popoverContent(_ content: AnyIdentifiable) -> some View {
        if let destination = content.destination as? MenuViewPopoverDestination {
            switch destination {
            case .tooltip:
                Text("Tooltip View")
            }
        }
    }
}

enum NavigationBarSheetDestination: Identifiable {
    case account(profile: Profile)
    case share
    
    var id: String { UUID().uuidString }
}

struct Profile: Equatable {
    let name: String
}

enum NavigationBarFullScreenCoverDestination: Identifiable {
    case search
    
    var id: String { UUID().uuidString }
}

#Preview {
    AppTabView()
}
