//
//  CastGridItem.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct CastGridItem: View {
    var name: String?
    var imageURl: URL?
    
    var body: some View {
        VStack {
            AsyncImageView(url: imageURl, size: .custom(width: 100, height: 140))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            HStack {
                Text(name ?? "")
                    .font(.caption)
                Spacer()
            }
        }
        .frame(minWidth: 100)
    }
}
