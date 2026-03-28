//
//  SearchView.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//
import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            Text("Search Content Here")
                .searchable(text: $searchText)
                .navigationTitle("Search")
        }
    }
}
