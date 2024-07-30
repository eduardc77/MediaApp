//
//  SecondView.swift
//  MediaApp
//

import SwiftUI

struct SecondView: View {
    @EnvironmentObject private var router: MenuViewRouter
    
    var body: some View {
        Form {
            Section {
                NavigationLink(value: SecondMenuDestination.detailView, label: {
                    Text("Navigate to Standings Detail View")
                })
            }
            Section {
                Button("Go back to Root View", action: { router.popToRoot() })
            }
        }
        .navigationTitle("Standings View")
        .navigationBar()
    }
}

#Preview {
    NavigationStack {
        SecondView()
    }
}
