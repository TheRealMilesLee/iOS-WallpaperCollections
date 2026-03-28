  //
  //  HomeView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel = HomeViewModel()
  @Namespace private var homeNamespace
    
  var body: some View {
      // 方案：让 NavigationView 包裹整个交互区域
    NavigationView {
      ZStack {
          // 层级 0：背景色
        Color(.systemGroupedBackground).ignoresSafeArea()
                
          // 层级 1：瀑布流主体
        ScrollView {
            // 探测器（可选）
          Text(
            "Total: \(viewModel.leftColumn.count + viewModel.rightColumn.count)"
          )
          .font(.caption)
                    
          HStack(alignment: .top, spacing: 12) {
            LazyVStack(spacing: 12) {
              ForEach(viewModel.leftColumn) { wallpaper in
                WallpaperCard(
                  wallpaper: wallpaper,
                  cornerRadius: 16,
                  viewModel: viewModel,
                  namespace: homeNamespace
                )
              }
            }
            LazyVStack(spacing: 12) {
              ForEach(viewModel.rightColumn) { wallpaper in
                WallpaperCard(
                  wallpaper: wallpaper,
                  cornerRadius: 16,
                  viewModel: viewModel,
                  namespace: homeNamespace
                )
              }
            }
          }
          .padding(12)
        }
          // 💡 重点 1：标题必须挂在 ScrollView 上
        .navigationTitle("The Collection")
          // 💡 重点 2：如果你想要大标题效果，可以显式声明
        .navigationBarTitleDisplayMode(.large)
        .refreshable { await viewModel.fetchRealWallpapers() }
                
          // 层级 2：详情页 Overlay
        if viewModel.showDetailPage, let wallpaper = viewModel.selectedWallpaper {
          WallpaperDetailView(
            wallpaper: wallpaper,
            viewModel: viewModel,
            namespace: homeNamespace
          )
          .transition(.move(edge: .bottom)) // 给详情页加个入场动画
          .zIndex(1) // 确保它在最上层
        }
      }
    }
    .navigationViewStyle(.stack)
    .task {
      await viewModel.fetchRealWallpapers()
    }
  }
}

struct WallpaperCard: View {
  let wallpaper: Wallpaper
  let cornerRadius: CGFloat
  @ObservedObject var viewModel: HomeViewModel
  let namespace: Namespace.ID

  var body: some View {
      // 给 Button 一个明确的可点击范围
    Button(
action: {
  withAnimation(
    .interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)
  ) {
    viewModel.selectedWallpaper = wallpaper
    viewModel.showDetailPage = true
  }
}) {
    // 给这个 VStack 一个框架保底
  VStack(spacing: 0) {
    AsyncImage(url: URL(string: wallpaper.imageUrl)) { phase in
      if case .success(let image) = phase {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .matchedGeometryEffect(id: wallpaper.id.uuidString, in: namespace)
      } else {
          // 如果加载失败或加载中，必须有一个占位符撑开空间！
        Rectangle()
          .fill(Color(.systemFill))
          .aspectRatio(9/16, contentMode: .fill)
          .matchedGeometryEffect(id: wallpaper.id.uuidString, in: namespace)
      }
    }
  }
    // 剪裁和圆角放在 Button 层面，或者里面，看具体效果
  .cornerRadius(cornerRadius)
  .clipped()
  .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
}
      // 为了让 Button 不会把内容颜色变蓝，必须加上这句，但要确保里面有占位符
.buttonStyle(.plain)
  }
}
