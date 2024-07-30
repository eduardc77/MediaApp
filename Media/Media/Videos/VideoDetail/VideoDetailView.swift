//
//  VideoDetailView.swift
//  MediaApp
//

import SwiftUI
import MediaNetwork

struct VideoDetailView: View {
    @ObservedObject private var viewModel: VideoDetailViewModel
    @EnvironmentObject private var modalRouter: ModalScreenRouter
    
    init(id: Int?, videosService: VideosServiceable) {
        self.viewModel = VideoDetailViewModel(videosService: videosService, id: id)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .empty:
                Label("No Data", systemImage: "newspaper")
                
            case .finished:
                ScrollView {
                    VStack {
                        DetailHeaderView(imageURL: viewModel.videoDetail?.posterURL(width: 500),
                                         title: viewModel.videoDetail?.title,
                                         rating: viewModel.videoDetail?.averageRating)
                        
                        if let data = viewModel.casts?.cast {
                            casts(data)
                        }
                        summary
                    }
                    .padding(.bottom)
                }
                .ignoresSafeArea(edges: .top)
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
                        Task {
                            await viewModel.fetchDetails()
                            await viewModel.fetchCast()
                        }
                    }
            }
        }
        .navigationBar()
    }
    
    @ViewBuilder
    private func casts(_ data: [Cast]) -> some View {
        VStack(alignment: .leading) {
            Text("Casts")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: columnGrid, spacing: 24) {
                    ForEach(data, id: \.id) { item in
                        CastGridItem(name: item.name,
                                     imageURl: item.imageURL(path: item.profilePath ?? "", width: 200))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    private var summary: some View {
        VStack(alignment: .leading) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text((viewModel.videoDetail?.overview == "" ? "Overview does not exist" : viewModel.videoDetail?.overview) ?? "")
                .font(.callout)
                .lineLimit(100)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal)
    }
    
    private var columnGrid: [GridItem] {
        return   [
            GridItem(.flexible())
        ]
    }
}

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailView(id: 787699, videosService: VideosService())
            .environmentObject(ModalScreenRouter())
    }
}
