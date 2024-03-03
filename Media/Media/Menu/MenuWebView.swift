//
//  MenuWebView.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct MenuWebView: View {
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    @Environment(\.dismiss) var dismiss
    let urlString: String
    var hasCloseButton: Bool = false
    
    var body: some View {
        MediaWebView(urlString: urlString)
            .navigationTitle("Web View")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if hasCloseButton {
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
