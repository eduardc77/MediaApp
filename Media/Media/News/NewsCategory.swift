//
//  NewsCategory.swift
//  Media
//

import Foundation

enum NewsCategory: CaseIterable {
    case all
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case .general:
            return "General"
        case .entertainment:
            return "Entertainment"
        case .business:
            return "Business"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        }
    }
    
    var imageName: String {
        switch self {
        case .all: 
            return "safari"
        case .business:
            return "suitcase"
        case .entertainment:
            return "popcorn"
        case .general:
            return "doc.richtext.th"
        case .health:
            return "stethoscope"
        case .science:
            return "atom"
        case .sports:
            return "sportscourt"
        case .technology:
            return "teletype.answer"
        }
    }
}

extension NewsCategory: Identifiable {
    var id: UUID {
        return UUID()
    }
}
