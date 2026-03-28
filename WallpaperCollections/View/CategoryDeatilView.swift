//
//  CategoryDeatilView.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//
import SwiftUI

struct CategoryDetailView: View {
  let category: GitHubContent
    // 这里我们复用之前的 HomeViewModel，但需要稍作修改
  @StateObject private var viewModel = HomeViewModel()
  @Namespace private var categoryNamespace
  
  var body: some View {
    ZStack {
      ScrollView {
          // 直接复用你 HomeView 里的 HStack + LazyVStack 逻辑
        HStack(alignment: .top, spacing: 12) {
            // ... 这里的代码和你 HomeView 里的 ForEach 逻辑完全一致 ...
            // 记得把 viewModel.fetchRealWallpapers 改为接受 path 参数
        }
        .padding()
      }
      .navigationTitle(category.name)
      .navigationBarTitleDisplayMode(.inline)
      
        // 同样支持 Hero 动画
      if viewModel.showDetailPage, let wallpaper = viewModel.selectedWallpaper {
        WallpaperDetailView(wallpaper: wallpaper, viewModel: viewModel, namespace: categoryNamespace)
          .ignoresSafeArea()
      }
    }
    .task {
        // 💡 关键：告诉 VM 加载这个特定的文件夹
      await viewModel.fetchRealWallpapers(at: category.path)
    }
  }
}
