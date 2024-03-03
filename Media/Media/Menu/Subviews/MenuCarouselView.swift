//
//  MenuCarouselView.swift
//  MediaApp
//

import SwiftUI

struct MenuCarouselView: View {
    @Binding var menuPath: NavigationPath
    var items: NumberList
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items.range, id: \.self) { item in
                    // Navigation Button
                    Button {
                        menuPath.append(item)
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
    @Binding var path: NavigationPath
    @State var number: Int
    
    var body: some View {
        Form {
            Section {
                Text("\(number)").font(.title)
            }
            Section {
                Button("Go back to root", action: { path.removeLast(path.count) })
            }
        }
        .navigationTitle("Carousel Item \(number)")
    }
}
