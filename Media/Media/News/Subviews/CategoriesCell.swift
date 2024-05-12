//
//  CategoriesCell.swift
//  Media
//

import SwiftUI

struct CategoriesCell: View {
    
    let image: String
    let title: String
    
    var body: some View {
        HStack {
            Label(
                title: { Text(title) },
                icon: { Image(systemName: image) }
            )
            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CategoriesCell_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesCell(image: "tec", title: "Technology")
            .previewLayout(.sizeThatFits)
    }
}
