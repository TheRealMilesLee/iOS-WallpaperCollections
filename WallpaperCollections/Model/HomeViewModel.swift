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
                                                     // 用于动画的 Namespace ID
  var namespaceId = UUID().uuidString
    
    // 用来记录已经加载过的图片 URL（作为唯一标识）
  private var loadedUrls = Set<String>()
  private let service = GitHubService()
    
  @MainActor
  func fetchRealWallpapers(at specifiedPath: String? = nil) async {
      // 防止重复加载
    guard !isLoading else { return }
    isLoading = true
    
      // 💡 核心逻辑：如果传入了 path（比如 Browse 传来的），就用它；
      // 否则，如果是首页，默认加载 "Unsplash"
    let targetPath = specifiedPath ?? "Unsplash"
    
    print("DEBUG: 准备从路径抓取图片 -> \(targetPath)")
    
    do {
        // 调用 Service，把这个 targetPath 传进去
      let allImages = try await service.fetchAllImages(path: targetPath)
      
      print("DEBUG: 抓取成功，数量: \(allImages.count)")
      
        // 只有拿到新图才处理
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
      print("DEBUG: 抓取失败，错误原因: \(error)")
    }
    
    isLoading = false
  }

}

