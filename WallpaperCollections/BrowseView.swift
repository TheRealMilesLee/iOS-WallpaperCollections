  //
  //  BrowseView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //
import SwiftUI

struct BrowseView: View {
  var body: some View {
    NavigationView {
      List {
        Text("Architecture")
        Text("Nature")
        Text("Minimalism")
      }
      .navigationTitle("Categories")
    }
  }
}
