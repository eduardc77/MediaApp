//
//  HomeView.swift
//  MediaApp
//

import SwiftUI
import MediaContentful

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var homeRouter: HomeViewRouter
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    var body: some View {
        baseView
            .navigationBar(title: "Home")    
    }
}

private extension HomeView {
    @ViewBuilder
    private var baseView: some View {
        switch viewModel.state {
        case .empty:
            Label("No Data", systemImage: "newspaper")
            
        case .finished:
            if let sections = viewModel.homeLayout?.sections, !sections.isEmpty {
                homeLayout(with: sections)
            }

        case .loading:
            ProgressView("Loading")
            
        case .error(error: let error):
            VStack {
                Label("Error", systemImage: "alert")
                Text(error)
            }
            .onAppear {
                modalRouter.presentAlert(title: "Error", message: error) {
                    Button("Ok") {
                        viewModel.changeState(.empty)
                    }
                }
            }
            
        case .initial:
            ProgressView()
                .onFirstAppear {
                    viewModel.fetchLayoutFromContentful()
                }
        }
    }
    
    func homeLayout(with sections: [LayoutSection]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(sections, id: \.self.sys.id) { section in
                    switch section.component {
                    case let component as HeroBanner:
                        HeroBannerView(router: homeRouter, model: component)
                        
                    case let component as VideoBanner:
                        VideoBannerView(router: homeRouter, model: component)
                        
                    case let component as Carousel:
                        CarouselView(router: homeRouter, model: component)
                        
                    default: EmptyView()
                    }
                }
            }
            .padding(.bottom)
        }
        .refreshable {
            viewModel.fetchLayoutFromContentful()
        }
    }
}


#Preview {
    HomeView()
        .environmentObject(AppTabRouter())
        .environmentObject(ModalScreenRouter())
}

