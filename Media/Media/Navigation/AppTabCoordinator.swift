//
//  AppTabCoordinator.swift
//  MediaApp
//

import Foundation

final class AppTabCoordinator: ObservableObject {
    @Published var selection: AppScreen = .home {
        willSet {
            if selection == newValue {
                tabReselected = true
            }
        }
    }
    
    /// Needed for going back to root view when tapping the already selected tab.
    @Published var tabReselected: Bool = false
}
