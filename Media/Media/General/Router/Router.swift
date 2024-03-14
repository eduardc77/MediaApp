//
//  AnyRouter.swift
//  Media
//

import Foundation

public protocol Router: ObservableObject {
    var path: [AnyHashable] { get }
    
    func push(_ screen: AnyHashable)
    func dismiss()
    func popToRoot()
    func openURL(_ url: URL)
}
