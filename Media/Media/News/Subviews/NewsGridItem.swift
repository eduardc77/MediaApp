//
//  NewsGridItem.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct NewsGridItem: View {
    let item: NewsItem
    @State var isEmpty = false
    
    init(item: NewsItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.overlay {
                AsyncImageView(url: URL(string: item.imageUrl), size: .custom(height: 120))
            }
            .frame(height: 120)
            .clipped()
            
            VStack(alignment: .leading, spacing: .xxxSmall) {
                Text(item.owner)
                    .lineLimit(1)
                    .font(.callout.weight(.bold))
                    .minimumScaleFactor(0.3)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.title)
                    .lineLimit(5)
                    .font(.callout.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Divider().padding(.horizontal, -10)
                
                Text(item.date)
                    .lineLimit(1)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
        }
        .frame(minWidth: 160, minHeight: 300, maxHeight: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct NewsItem {
    let imageUrl: String
    let owner: String
    let title: String
    let date: String
}

extension String {
    func timestampString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.unitsStyle = .abbreviated
        guard let date = dateFormatter.date(from: self) else { return "" }
        return relativeDateTimeFormatter.localizedString(for: date, relativeTo: Date())
    }
}

