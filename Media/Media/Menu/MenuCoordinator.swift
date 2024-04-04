//
//  HomCoordinator.swift
//  MediaApp
//

import SwiftUI

struct MenuCoordinator: View {
    @StateObject private var router = MenuViewRouter()
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MenuView()
                .navigationDestination(for: AnyHashable.self) { destination in
                    switch destination {
                    case let menuDestination as MenuDestination:
                        self.menuDestination(destination: menuDestination)
                    case let secondMenuDestination as SecondMenuDestination:
                        self.secondMenuDestination(destination: secondMenuDestination)
                    case let number as Int:
                        NumberView(router: router, number: number)
                    default:
                        EmptyView()
                    }
                }
        }
        .confirmationDialog($modalRouter.confirmationDialog)
        .onReceive(tabCoordinator.$tabReselected) { tabReselected in
            guard tabReselected, tabCoordinator.selection == .menu, !router.path.isEmpty else { return }
            router.popToRoot()
        }
        .environmentObject(router)
        
    }
    
    @ViewBuilder
    private func menuDestination(destination: MenuDestination) -> some View {
        switch destination {
        case .menuChildView:
            MenuChildView()
        case .menuDetailView:
            MenuDetailView()
        case .menuDetailView2:
            Text("New Screen")
        }
    }
    
    @ViewBuilder
    private func secondMenuDestination(destination: SecondMenuDestination) -> some View {
        switch destination {
        case .menuWebView(let urlString):
            MenuWebView(urlString: urlString)
        case .secondView:
            SecondView()
        case .thirdView:
            Text("Third View")
        case .detailView:
            SecondDetailView()
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
    case secondView
    case thirdView
    case detailView
}

enum MenuSheetDestination: Identifiable {
    case menuWebViewSheet(urlString: String)
    
    var id: String { UUID().uuidString }
}

enum MenuFullScreenCoverDestination: Identifiable {
    case menuWebViewFullScreenCover(urlString: String)
    
    var id: String { UUID().uuidString }
}

#Preview {
    MenuCoordinator()
        .environmentObject(AppTabRouter())
        .environmentObject(ModalScreenRouter())
}
