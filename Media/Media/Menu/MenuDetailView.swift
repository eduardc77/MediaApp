//
//  MenuDetailView.swift
//  Tournaments
//

import SwiftUI

struct MenuDetailView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Form {          
            Section {
                Button("Push New Screen", action: { path.append(MenuDestination.menuDetailView2) })
            }
            Section {
                Button("Go back to Menu Child View", action: { path.removeLast() })
                Button("Go back to Root View", action: { path.removeLast(path.count) })
            }
        }
        .navigationTitle("Menu Detail View")
        .navigationBar()
    }
}

//#Preview {
//    MenuDetailView()
//}
