//
//  ViewState.swift
//  MediaApp
//

enum ViewState: ViewStateProtocol {
    case initial
    case loading
    case finished
    case error(error: String)
    case empty
}

extension ViewState: Equatable {}
