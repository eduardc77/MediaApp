//
//  DiscoverView.swift
//  MediaApp
//

import SwiftUI

struct DiscoverView: View {
    var allCategories: [NewsCategory] = NewsCategory.allCases
    
    @EnvironmentObject private var router: NewsViewRouter
    @EnvironmentObject private var tabCoordinator: AppTabRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20, alignment: .leading)]) {
                ForEach(Array(allCategories.enumerated()), id: \.offset) { index, category in
                    Button {
                        router.push(category)
                    } label: {
                        CategoriesCell(image: category.imageName, title: category.title)
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle("Categories")
    }
}
