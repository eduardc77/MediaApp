//
//  MenuChildView.swift
//  MediaApp
//

import SwiftUI

struct MenuChildView: View {
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    @Binding  var navigationPath: NavigationPath
    
    var body: some View {
        Form {
            Section {
                NavigationLink(value: MenuDestination.menuDetailView, label: {
                    Text("Navigate to Detail View")
                })
            }
            Section {
                Button("Select Menu Tab") {
                    tabCoordinator.selection = .menu
                }
            }
            Section {
                Button("Go back to Root View", action: { navigationPath.removeLast(navigationPath.count) })
            }
        }
        .navigationTitle("Menu Child View")
        .navigationBar()
    }
}

//#Preview {
//    NavigationStack {
//        MenuChildView()
//    }
//}
