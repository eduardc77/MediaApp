//
//  SearchView.swift
//  MediaApp
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView {
            
        }
        .navigationTitle("Search")
        .searchable(text: $searchText)
    }
}

//#Preview {
//    SearchView()
//}
