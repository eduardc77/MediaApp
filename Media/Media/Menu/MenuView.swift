//
//  MenuView.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct MenuView: View {
    @EnvironmentObject private var router: MenuViewRouter
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    @EnvironmentObject private var settings: AppSettings
    
    private let urlString = "https://www.apple.com"
    
    var body: some View {
        Form {
            Section {
                appThemeColorPicker
                displayAppearancePicker
            } header: {
                Text("Preferences")
            }
            
            Section("Navigate through Path") {
                NavigationButton {
                    router.push(MenuDestination.menuChildView)
                } label: {
                    Text("Navigate to Menu Child View")
                }
                
                NavigationButton {
                    router.push(SecondMenuDestination.secondView)
                } label: {
                    Text("Navigate to Second View")
                }
                
                NavigationButton {
                    router.push(SecondMenuDestination.thirdView)
                } label: {
                    Text("Navigate to Third View")
                }
            }
            
            Section("Carousel Navigation Example") {
                MenuCarouselView(router: router, items:  NumberList(range: 0 ..< 10))
            }
            
            Section("iPad Popovers") {
                Button("Present Popover") {
                    modalRouter.presentPopover(destination: MenuViewPopoverDestination.tooltip,
                                               attachmentAnchor: .point(.top),
                                               arrowEdge: .bottom) }
            }
            Section("Web View Navigation and Presenters") {
                NavigationButton {
                    tabCoordinator.urlString = urlString
                } label: {
                    Label("External Link", systemImage: "link")
                }
                
                NavigationButton {
                    router.push(SecondMenuDestination.menuWebView(urlString: urlString))
                } label: {
                    Text("Navigate to In App WebView")
                }
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
            
            Section {
                
            } header: {
                VStack {
                    Text("Media App")
                    Text(settings.appVersion ?? "")
                }
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
            }
            .listRowInsets(.none)
            .listRowBackground(Color.clear)
        }
        .navigationBar(title: "Menu", displayMode: .large)
    }
    
    var appThemeColorPicker: some View {
        Picker(selection: settings.$theme) {
            ForEach(AppSettings.Theme.allCases, id: \.self) { theme in
                Text(theme.title)
                    .tag(theme)
            }
        } label: {
            SettingsLabel(settingsOption: .appColor)
        }
        .tint(.secondary)
        .frame(height: 20)
    }
    
    var displayAppearancePicker: some View {
        Picker(selection: settings.$displayAppearance) {
            ForEach(AppSettings.DisplayAppearance.allCases, id: \.self) { displayAppearance in
                displayAppearance.title
                    .tag(displayAppearance)
                
            }
        } label: {
            SettingsLabel(settingsOption: .displayAppearance)
        }
        .tint(.secondary)
        .frame(height: 20)
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
