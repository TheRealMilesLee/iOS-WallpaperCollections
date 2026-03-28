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
    // --- Hero Animation 状态管理 ---
  @Published var selectedWallpaper: Wallpaper? = nil // 当前被选中的壁纸
  @Published var showDetailPage: Bool = false        // 是否显示详情页
 // 为了方便搜索，我们在 VM 里维护一个扁平的总表
  @Published var allWallpapers: [Wallpaper] = []
  @Published var searchText: String = ""
  var namespaceId = UUID().uuidString
    
    // 用来记录已经加载过的图片 URL（作为唯一标识）
  private var loadedUrls = Set<String>()
  private let service = GitHubService()
    
  @MainActor
  func fetchRealWallpapers(at specifiedPath: String? = nil) async {
      // 防止重复加载
    guard !isLoading else { return }
    isLoading = true
    
    let targetPath = specifiedPath ?? "2026 Wallpaper"
    
    print("DEBUG: 准备从路径抓取图片 -> \(targetPath)")
    
    do {
      let allImages = try await service.fetchAllImages(path: targetPath)
      let newImages = allImages.filter { !loadedUrls.contains($0.imageUrl) }
      
      for image in newImages {
        self.loadedUrls.insert(image.imageUrl)
          // 💡 重点：维护总表
        self.allWallpapers.append(image)
        
          // 原有的瀑布流分发逻辑
        if self.leftColumn.count <= self.rightColumn.count {
          self.leftColumn.append(image)
        } else {
          self.rightColumn.append(image)
        }
      }
    } catch {
      print("Fetch error: \(error)")
    }
    
    isLoading = false
  }

}

