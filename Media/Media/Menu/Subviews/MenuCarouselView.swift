//
//  MenuCarouselView.swift
//  MediaApp
//

import SwiftUI

struct MenuCarouselView: View {
    var router: any Router
    var items: NumberList
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items.range, id: \.self) { item in
                    // Navigation Button
                    Button {
                        router.push(item)
                    } label: {
                        Text("Carousel Item \(item)")
                            .padding()
                            .frame(height: 100)
                            .background(.secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}

struct NumberList: Hashable {
    let range: Range<Int>
}

struct NumberView: View {
    var router: any Router
    @State var number: Int
    
    var body: some View {
        Form {
            Section {
                Text("\(number)").font(.title)
            }
            Section {
                Button("Go back to root", action: { router.popToRoot() })
            }
        }
        .navigationTitle("Carousel Item \(number)")
    }
}
