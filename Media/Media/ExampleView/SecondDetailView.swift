//
//  SecondDetailView.swift
//  MediaApp
//

import SwiftUI

struct SecondDetailView: View {
    @EnvironmentObject private var router: MenuViewRouter
    
    var body: some View {
        Form {
            Section {
                Button("Go back to Standings View", action: { router.pop() })
                Button("Go back to Root View", action: { router.popToRoot() })
            }
        }
        .navigationTitle("Standings Detail View")
        .navigationBar()
    }
}

#Preview {
    SecondDetailView()
}
