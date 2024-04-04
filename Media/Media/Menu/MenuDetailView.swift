//
//  MenuDetailView.swift
//  Tournaments
//

import SwiftUI

struct MenuDetailView: View {
    @EnvironmentObject private var router: MenuViewRouter
    
    var body: some View {
        Form {
            Section {
                Button("Push New Screen", action: { router.push(MenuDestination.menuDetailView2)
                })
            }
            
            Section {
                Button("Go back to Menu Child View", action: { router.pop() })
                Button("Go back to Root View", action: { router.popToRoot() })
            }
            .navigationTitle("Menu Detail View")
            .navigationBar()
        }
    }
}

#Preview {
    MenuDetailView()
}
