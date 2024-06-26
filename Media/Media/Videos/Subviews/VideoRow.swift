//
//  VideoRow.swift
//  Media
//

import SwiftUI
import MediaUI

struct VideoRow: View {
    let item: VideoItem

    init(item: VideoItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            AsyncImageView(url: item.imageUrl, size: .custom(height: 100))
                .clipShape(RoundedRectangle(cornerRadius: 8))
       
                VStack(alignment: .leading) {
                    Text(item.title)
                        .lineLimit(2)
                        .font(.callout.weight(.medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(item.date)
                        .lineLimit(1)
                        .font(.footnote.weight(.medium))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(8)
        }
    }
}
