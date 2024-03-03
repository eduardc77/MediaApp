//
//  StandingsView.swift
//  MediaApp
//

import SwiftUI

struct StandingsView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Form {
            Section {
                NavigationLink(value: SecondMenuDestination.standingsDetailView, label: {
                    Text("Navigate to Standings Detail View")
                })
            }
            Section {
                Button("Go back to Root View", action: { path.removeLast(path.count) })
            }
        }
        .navigationTitle("Standings View")
        .navigationBar()
    }
}

//#Preview {
//    NavigationStack {
//        StandingsView()
//    }
//}
