//
//  HomeViewModel.swift
//  MediaApp
//

import Foundation
import Contentful
import MediaContentful

final class HomeViewModel: BaseViewModel<ViewState> {
    @Published var homeLayout: PageLayout?
    
    private let contentful = ContentfulService.shared.contentful
    private weak var layoutRequest: URLSessionTask?
    
    private var layoutQuery: QueryOn<PageLayout> {
        let localeCode = contentful.currentLocaleCode
        /// Search for the 'home layout' by its slug.
        let query = QueryOn<PageLayout>.where(field: .slug, .equals("home-page-layout")).localizeResults(withLocaleCode: localeCode)
        /**
         Include links that are two levels deep in the API response. In this case, specifying
         4 levels deep will give us the home layout > it's sections > section's component > component's group data
         (e.g. it's articles and their image.)
         */
        query.include(4)
        return query
    }
    
    func fetchLayoutFromContentful() {
        guard state != .loading else { return }
        resetLayoutData()
        //contentful.setLocale(Contentful.Locale.german())
        
        layoutRequest = contentful.client.fetchArray(of: PageLayout.self, matching: layoutQuery) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let arrayResponse):
                    guard let sections = arrayResponse.items.first?.sections,
                          !sections.isEmpty,
                          let layout = arrayResponse.items.first else {
                        print("No Sections found for Home Layout.")
                        return
                    }
                    self.homeLayout = layout
                    self.changeState(.finished)
                    //self.resolveStatesOnSections()
                    
                case .failure(let error):
                    print(error)
                    self.changeState(.error(error: error.localizedDescription))
                }
            }
        }
    }
}

//MARK: - Private Methods

private extension HomeViewModel {
    
    func resetLayoutData() {
        changeState(.loading)
        homeLayout = nil
        // Cancel the previous request before making a new one.
        layoutRequest?.cancel()
    }
    
    func resolveStatesOnSections() {
        guard let homeLayout = self.homeLayout else { return }
        
        contentful.willResolveStateIfNecessary(for: homeLayout) { [weak self] (result: Result<PageLayout, Error>, deliveryHomeLayout: PageLayout?) in
            guard let self = self else { return }
            switch result {
            case .success(var statefulPreviewHomeLayout):
                guard let statefulPreviewHomeModules = statefulPreviewHomeLayout.sections,
                      let deliveryModules = deliveryHomeLayout?.sections
                else {
                    
                    return
                }
                statefulPreviewHomeLayout = self.contentful.inferStateFromLinkedModuleDiffs(
                    statefulRootAndModules: (statefulPreviewHomeLayout, statefulPreviewHomeModules),
                    deliveryModules: deliveryModules
                )
                
            case .failure:
                break
            }
        }
    }
}
