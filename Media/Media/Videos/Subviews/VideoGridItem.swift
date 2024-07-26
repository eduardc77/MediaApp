//
//  VideoGridItem.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct VideoGridItem: View {
    let item: VideoItem
    
    init(item: VideoItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageUrl = item.imageUrl {
                AsyncImageView(url: imageUrl, size: .custom(height: 240))
                    .clipped()
            } else {
                Color.secondary.frame(height: 240)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .lineLimit(2)
                    .font(.callout.weight(.medium))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                Text(item.date)
                    .lineLimit(1)
                    .font(.footnote.weight(.medium))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(8)
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct VideoItem {
    let imageUrl: URL?
    let title: String
    let date: String
}
