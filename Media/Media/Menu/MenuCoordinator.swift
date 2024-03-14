//
//  HomCoordinator.swift
//  MediaApp
//

import SwiftUI

struct MenuCoordinator: View {
    @State private var menuNavigationPath = NavigationPath()
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        NavigationStack(path: $menuNavigationPath) {
            MenuView(menuPath: $menuNavigationPath)
                .navigationDestination(for: MenuDestination.self, destination: menuDestination)
                .navigationDestination(for: SecondMenuDestination.self, destination: secondMenuDestination)
                .navigationDestination(for: Int.self, destination: { number in
                    NumberView(path: $menuNavigationPath, number: number)
                })
        }
        .confirmationDialog($modalRouter.confirmationDialog)
    }
    
    @ViewBuilder
    private func menuDestination(destination: MenuDestination) -> some View {
        switch destination {
        case .menuChildView:
            MenuChildView(navigationPath: $menuNavigationPath)
        case .menuDetailView:
            MenuDetailView(path: $menuNavigationPath)
        case .menuDetailView2:
            Text("New Screen")
        }
    }
    
    @ViewBuilder
    private func secondMenuDestination(destination: SecondMenuDestination) -> some View {
        switch destination {
        case .menuWebView(let urlString):
            MenuWebView(urlString: urlString)
        case .standingsView:
            StandingsView(path: $menuNavigationPath)
        case .standingsDetailView:
            StandingsDetailView(path: $menuNavigationPath)
        case .groupsView:
            Text("Groups Screen")
        }
    }
}

enum MenuDestination: Hashable {
    case menuChildView
    case menuDetailView
    case menuDetailView2
}

enum SecondMenuDestination: Hashable {
    case menuWebView(urlString: String)
    case standingsView
    case standingsDetailView
    case groupsView
}

enum MenuSheetDestination: Identifiable {
    case menuWebViewSheet(urlString: String)
    
    var id: String { UUID().uuidString }
}

enum MenuFullScreenCoverDestination: Identifiable {
    case menuWebViewFullScreenCover(urlString: String)
    
    var id: String { UUID().uuidString }
}

struct MenuCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        MenuCoordinator()
            .environmentObject(AppTabRouter())
            .environmentObject(ModalScreenRouter())
    }
}
