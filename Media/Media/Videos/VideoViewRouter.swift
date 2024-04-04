//
//  VideoViewRouter.swift
//  Media
//

import Foundation

final class VideoViewRouter: Router {
    @Published var path = [AnyHashable]()

    init() {}
    
    func push(_ screen: AnyHashable) {
        path.push(screen)
    }
    
    func dismiss() {
        path.pop()
    }
    
    func popTo(_ screen: AnyHashable) {
        path.popTo(screen)
    }
    
    func pop(_ count: Int = 1) {
        path.pop(count)
    }
    
    func popTo(index: Int) {
        path.popTo(index)
    }
    
    func popToRoot() {
        path.popToRoot()
    }
}
