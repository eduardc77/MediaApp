//
//  SearchCoordinator.swift
//  MediaApp
//

import SwiftUI

struct SearchCoordinator: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            SearchView()
                .toolbar {
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark")
                    }
                    .tint(.primary)
                }
        }
    }
}

//#Preview {
//    SearchCoordinator()
//}
