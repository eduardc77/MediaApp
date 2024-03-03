//
//  AuthorViewExample.swift
//  MediaApp
//

import SwiftUI
import MediaContentful

final class AuthorViewExample: UIView, ResourceLinkBlockViewRepresentable {
    private enum Constant {
        static let padding: CGFloat = 12.0
    }
    
    private let author: Author
    private var imageView: UIImageView!
    private var title: UILabel!
    
    var context: [CodingUserInfoKey : Any] = [:]
    
    public init(author: Author) {
        self.author = author
        super.init(frame: .init(x: 0, y: 0, width: 1, height: 1))
        
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: Constant.padding
        ).isActive = true
        
        imageView.bottomAnchor.constraint(
            lessThanOrEqualTo: bottomAnchor,
            constant: -Constant.padding
        ).isActive = true
        
        imageView.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: Constant.padding
        ).isActive = true
        
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = author.name
        title.textColor = UIColor.label
        title.numberOfLines = 0
        addSubview(title)
        
        title.topAnchor.constraint(
            equalTo: topAnchor,
            constant: Constant.padding
        ).isActive = true
        
        title.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -Constant.padding
        ).isActive = true
        
        title.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -Constant.padding
        ).isActive = true
        
        title.leadingAnchor.constraint(
            equalTo: imageView.trailingAnchor
        ).isActive = true
        
        backgroundColor = UIColor.systemBackground
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .init(width: 0, height: 0)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.25
        
        imageView.downloaded(from: author.avatar?.urlString ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(with width: CGFloat) {
        layoutIfNeeded()
        
        var rect = frame
        rect.size.width = width
        
        let titleSize = title.sizeThatFits(.init(width: title.bounds.width, height: .infinity))
        let titleHeight = titleSize.height
        let imageHeight = imageView.frame.height
        
        rect.size.height = titleHeight + imageHeight
        self.frame = rect
    }
}
