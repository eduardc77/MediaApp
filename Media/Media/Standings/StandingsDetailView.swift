//
//  StandingsDetailView.swift
//  MediaApp
//

import SwiftUI

struct StandingsDetailView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Form {
            Section {
                Button("Go back to Standings View", action: { path.removeLast() })
                Button("Go back to Root View", action: { path.removeLast(path.count) })
            }
        }
        .navigationTitle("Standings Detail View")
        .navigationBar()
    }
}

//#Preview {
//    StandingsDetailView()
//}
