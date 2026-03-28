//
//  BrowserViewModel.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import SwiftUI
import Combine

class BrowseViewModel: ObservableObject {
  @Published var categories: [GitHubContent] = []
  @Published var isLoading = false
  private let service = GitHubService()
  
  @MainActor
  func loadCategories() async {
    isLoading = true
    do {
      self.categories = try await service.fetchCategories()
    } catch {
      print("Browse Load Failed: \(error)")
    }
    isLoading = false
  }
}

