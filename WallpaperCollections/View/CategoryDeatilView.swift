//
//  CategoryDeatilView.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//
import SwiftUI

struct CategoryDetailView: View {
  let category: GitHubContent // 接收传递过来的目录信息
  
    // 复用 HomeViewModel，它现在是个通用 VM
  @StateObject private var viewModel = HomeViewModel()
    // 为这个特定详情页定义一个新的 Namespace
  @Namespace private var detailNamespace
  
  var body: some View {
    ZStack {
        // 层级 1：瀑布流主体
      ScrollView {
          // 直接贴入你 HomeView 里的布局代码
        HStack(alignment: .top, spacing: 12) {
          LazyVStack(spacing: 12) {
            ForEach(viewModel.leftColumn) { wallpaper in
              WallpaperCard(
                wallpaper: wallpaper,
                cornerRadius: 16,
                viewModel: viewModel,
                namespace: detailNamespace // 传递这个页面专属的 Namespace
              )
            }
          }
          
          LazyVStack(spacing: 12) {
            ForEach(viewModel.rightColumn) { wallpaper in
              WallpaperCard(
                wallpaper: wallpaper,
                cornerRadius: 16,
                viewModel: viewModel,
                namespace: detailNamespace // 传递这个页面专属的 Namespace
              )
            }
          }
        }
        .padding(12)
      }
      .navigationTitle(category.name) // 标题设为文件夹名
      .navigationBarTitleDisplayMode(.inline) // 详情页通常用 inline 标题
      .refreshable { await viewModel.fetchRealWallpapers(at: category.path) }
      
        // 层级 2：详情页 Overlay
      if viewModel.showDetailPage, let wallpaper = viewModel.selectedWallpaper {
        WallpaperDetailView(
          wallpaper: wallpaper,
          viewModel: viewModel,
          namespace: detailNamespace // 传递同一个 Namespace
        )
        .transition(.move(edge: .bottom))
        .zIndex(1)
      }
    }
    .task {
        // 💡 重点：在页面出现时，告诉 VM 加载这个特定的文件夹
      await viewModel.fetchRealWallpapers(at: category.path)
    }
  }
}
