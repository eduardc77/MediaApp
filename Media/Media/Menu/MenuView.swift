//
//  MenuView.swift
//  MediaApp
//

import SwiftUI

struct MenuView: View {
    @Binding var menuPath: NavigationPath
    
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter

    private let urlString = "https://www.apple.com"
    
    var body: some View {
        Form {
            Section("Navigate through Path") {
                NavigationLink(value: MenuDestination.menuChildView, label: {
                    Text("Navigate to Menu Child View")
                })
                NavigationLink(value: SecondMenuDestination.standingsView, label: {
                    Text("Navigate to Standings View")
                })
                NavigationLink(value: SecondMenuDestination.groupsView, label: {
                    Text("Navigate to Groups View")
                })
            }
            Section("Carousel Navigation Example") {
                MenuCarouselView(menuPath: $menuPath, items:  NumberList(range: 0 ..< 10))
            }
            
            Section("iPad Popovers") {
                Button("Present Popover") {
                    modalRouter.presentPopover(destination: MenuViewPopoverDestination.tooltip,
                                               attachmentAnchor: .point(.top),
                                               arrowEdge: .bottom) }
            }
            Section("Web View Navigation and Presenters") {
                Button {
                    tabCoordinator.urlString = urlString
                } label: {
                    Label("External Link", systemImage: "link")
                }
                
                NavigationLink(value: SecondMenuDestination.menuWebView(urlString: urlString), label: {
                    Text("Navigate to In App WebView")
                })
                webViewSheetButton
                webViewFullScreenCoverButton
            }
            
            Section("Alert Presenters") {
                Button("Present Alert") {
                    modalRouter.presentAlert(title: "Alert", message: "Alert Message", buttons: { alertButtons })
                }
                Button("Present Confirmation Dialog") {
                    modalRouter.presentConfirmationDialog(title: "Confirmation Dialog", buttons: { alertButtons })
                }
            }
        }
        .navigationBar(title: "Menu", displayMode: .large)
        .onReceive(tabCoordinator.$tabReselected) { tabReselected in
            guard tabReselected, tabCoordinator.selection == .menu, !menuPath.isEmpty else { return }
            menuPath.removeLast(menuPath.count)
        }
    }
}

// MARK: - Subviews

private extension MenuView {
    
    @ViewBuilder
    var alertButtons: some View {
        Button(role: .none) {
            
        } label: {
            Text("Default")
        }
        Button(role: .cancel) {
            
        } label: {
            Text("Cancel")
        }
        Button(role: .destructive) {
            
        } label: {
            Text("Destructive")
        }
    }
    
    var webViewSheetButton: some View {
        Button("Present In App WebView Sheet") {
            modalRouter.presentSheet(destination: MenuSheetDestination.menuWebViewSheet(urlString: urlString))
        }
    }
    
    var webViewFullScreenCoverButton: some View {
        Button("Present Full Screen Cover WebView") {
            modalRouter.presentFullScreenCover(destination: MenuFullScreenCoverDestination.menuWebViewFullScreenCover(urlString: urlString))
        }
    }
}

enum MenuViewPopoverDestination: Identifiable {
    case tooltip
    
    var id: String { UUID().uuidString }
}
