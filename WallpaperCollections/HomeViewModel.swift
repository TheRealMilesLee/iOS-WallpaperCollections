//
//  HomeViewModel.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var leftColumn: [Wallpaper] = []
    @Published var rightColumn: [Wallpaper] = []
    @Published var isLoading = false
    
    // 用来记录已经加载过的图片 URL（作为唯一标识）
    private var loadedUrls = Set<String>()
    private let service = GitHubService()
    
    @MainActor
        func fetchRealWallpapers() async {
            guard !isLoading else { return }
            isLoading = true
            
            do {
                // 真正执行异步等待
                let allImages = try await service.fetchAllImages(path: "Unsplash")
                
                let newImages = allImages.filter { !loadedUrls.contains($0.imageUrl) }
                
                for image in newImages {
                    self.loadedUrls.insert(image.imageUrl)
                    if self.leftColumn.count <= self.rightColumn.count {
                        self.leftColumn.append(image)
                    } else {
                        self.rightColumn.append(image)
                    }
                }
            } catch {
                print("Fetch failed: \(error)")
            }
            
            isLoading = false
        }
}

