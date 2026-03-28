  //
  //  SearchView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //
import SwiftUI

struct SearchView: View {
    // 每一个 Tab 拥有自己独立的 VM 实例，或者共用（看你的架构设计）
    // 建议搜索页独立一个 VM 以保持复杂度可控
  @StateObject private var viewModel = HomeViewModel()
  @Namespace private var searchNamespace
  
  var body: some View {
    NavigationView {
      ZStack {
        Color(.systemGroupedBackground).ignoresSafeArea()
        
        ScrollView {
            // 使用我们之前重构的通用瀑布流组件
            // 传入过滤后的结果：viewModel.filteredWallpapers
          WaterfallLayout(
            wallpapers: viewModel.filteredWallpapers,
            namespace: searchNamespace,
            viewModel: viewModel
          )
        }
        .navigationTitle("Search")
          // 💡 接入系统搜索协议
        .searchable(text: $viewModel.searchText, prompt: "Search in '\(viewModel.allWallpapers.count)' wallpapers...")
        
          // 同样支持 Hero 动画详情页
        if viewModel.showDetailPage, let wallpaper = viewModel.selectedWallpaper {
          WallpaperDetailView(wallpaper: wallpaper, viewModel: viewModel, namespace: searchNamespace)
            .ignoresSafeArea()
        }
      }
    }
    .task {
        // 搜索页可以尝试抓取根目录，构建全局索引
      await viewModel.fetchRealWallpapers(at: "")
    }
  }
}

extension HomeViewModel {
    // 动态过滤后的列表
  var filteredWallpapers: [Wallpaper] {
    if searchText.isEmpty {
      return allWallpapers // 假设我们将 left/right 合并为一个总表 allWallpapers
    } else {
      return allWallpapers.filter {
        $0.imageUrl.lowercased().contains(searchText.lowercased()) ||
        $0.author.lowercased().contains(searchText.lowercased())
      }
    }
  }
  

}

struct WaterfallLayout: View {
  let wallpapers: [Wallpaper]
  let namespace: Namespace.ID
  @ObservedObject var viewModel: HomeViewModel
  
    // 动态计算分列逻辑
  var leftColumn: [Wallpaper] {
    wallpapers.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
  }
  var rightColumn: [Wallpaper] {
    wallpapers.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      LazyVStack(spacing: 12) {
        ForEach(leftColumn) { wallpaper in
          WallpaperCard(wallpaper: wallpaper, cornerRadius: 16, viewModel: viewModel, namespace: namespace)
        }
      }
      LazyVStack(spacing: 12) {
        ForEach(rightColumn) { wallpaper in
          WallpaperCard(wallpaper: wallpaper, cornerRadius: 16, viewModel: viewModel, namespace: namespace)
        }
      }
    }
    .padding(12)
  }
}
