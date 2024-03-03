//
//  NavigationBarModifier.swift
//  MediaApp
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var title: String?
    var displayMode: NavigationBarItem.TitleDisplayMode = .inline
    
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(displayMode)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    searchToolbarItem
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    shareToolbarItem
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    profileToolbarItem
                }
            })
    }
    
    private var searchToolbarItem: some View {
        Button { [weak modalRouter] in
            guard let modalRouter = modalRouter else { return }
            modalRouter.presentFullScreenCover(destination: NavigationBarFullScreenCoverDestination.search)
        } label: {
            Label("Search", systemImage: "magnifyingglass")
        }
    }
    
    private var profileToolbarItem: some View {
        Button { [weak modalRouter] in
            guard let modalRouter = modalRouter else { return }
            modalRouter.presentSheet(destination: NavigationBarSheetDestination.account(profile: Profile(name: "John Appleseed")))
        } label: {
            Label("Account", systemImage: "person.crop.circle")
        }
    }
    
    private var shareToolbarItem: some View {
        Button { [weak modalRouter] in
            guard let modalRouter = modalRouter else { return }
            modalRouter.presentSheet(destination: NavigationBarSheetDestination.share)
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}

extension View {
    func navigationBar(title: String? = nil, displayMode: NavigationBarItem.TitleDisplayMode = .inline) -> some View {
        modifier(NavigationBarModifier(title: title, displayMode: displayMode))
    }
}
