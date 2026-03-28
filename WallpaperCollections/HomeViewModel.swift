//
//  HomeViewModel.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // 公开给 View 观察的两列数据
    @Published var leftColumn: [Wallpaper] = []
    @Published var rightColumn: [Wallpaper] = []
    @Published var isLoading = false
    
    init() {
        // 初始化时加载数据
        fetchWallpapers()
    }
    
    func fetchWallpapers() {
        isLoading = true
        
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // 这里是 Mock 数据，基于你的 GitHub 仓库结构假设
            let mockData = [
                Wallpaper(imageUrl: "https://raw.githubusercontent.com/TheRealMilesLee/The-Wallpaper-Collection/main/images/mountain_01.jpg", author: "Miles", width: 400, height: 600),
                Wallpaper(imageUrl: "https://raw.githubusercontent.com/TheRealMilesLee/The-Wallpaper-Collection/main/images/city_01.jpg", author: "Urban Shot", width: 400, height: 300),
                Wallpaper(imageUrl: "https://raw.githubusercontent.com/TheRealMilesLee/The-Wallpaper-Collection/main/images/minimal_01.jpg", author: "Zen", width: 400, height: 400),
                Wallpaper(imageUrl: "https://raw.githubusercontent.com/TheRealMilesLee/The-Wallpaper-Collection/main/images/abstract_01.jpg", author: "AI Art", width: 400, height: 700),
                Wallpaper(imageUrl: "https://raw.githubusercontent.com/TheRealMilesLee/The-Wallpaper-Collection/main/images/nature_02.jpg", author: "Forest", width: 400, height: 550)
            ]
            
            // 简单的瀑布流分配算法：
            // 为了保持两列高度接近，我们比较当前两列的数据量（真实算法需要比较高度之和）
            for (index, wallpaper) in mockData.enumerated() {
                if index % 2 == 0 {
                    self.leftColumn.append(wallpaper)
                } else {
                    self.rightColumn.append(wallpaper)
                }
            }
            
            self.isLoading = false
        }
    }
}
