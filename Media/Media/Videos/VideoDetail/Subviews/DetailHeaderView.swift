//
//  VideoDetailHeaderView.swift
//  MediaApp
//

import SwiftUI
import MediaUI

struct DetailHeaderView: View {
    var imageURL: URL?
    var title: String?
    var rating: Double?
    
    var body: some View {
        ZStack {
            videoImage
                .opacity(0.3)
            VStack {
                videoImage
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: UIScreen.main.bounds.size.height / 3)
                
                VStack(spacing: 4) {
                    Text(title ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.horizontal)
                    
                    RatingView(rating: rating)
                }
            }
            .padding(.top, 42)
        }
    }
    
    @ViewBuilder
    private var videoImage: some View {
        if let imageURL = imageURL {
            AsyncImageView(url: imageURL, contentMode: .fit)
        } else {
            Rectangle()
                .fill(.tertiary)
        }
    }
}

struct RatingView: View {
    var rating: Double?
    var maxRating = 5
    
    var offColor = Color.gray
    var onColor = Color.orange
    
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { number in
                Image(systemName: "star.fill")
                    .resizable()
                    .foregroundStyle(number > Int(rating ?? 0) / 2 ? offColor : onColor)
                    .frame(width: 24, height: 24)
            }
        }
    }
}
