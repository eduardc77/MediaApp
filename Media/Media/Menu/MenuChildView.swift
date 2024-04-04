//
//  MenuChildView.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct MenuChildView: View {
    @EnvironmentObject private var router: MenuViewRouter
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    
    var body: some View {
        Form {
            Section {
                NavigationButton {
                    router.push(MenuDestination.menuDetailView)
                } label: {
                    Text("Navigate to Detail View")
                }
            }
            Section {
                Button("Select Menu Tab") {
                    tabCoordinator.selection = .menu
                }
            }
            Section {
                NavigationButton {
                    router.popToRoot()
                } label: {
                    Text("Go back to Root View")
                }
            }
        }
        .navigationTitle("Menu Child View")
        .navigationBar()
    }
}

#Preview {
    NavigationStack {
        MenuChildView()
    }
}
