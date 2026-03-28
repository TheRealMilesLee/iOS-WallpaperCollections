  //
  //  HomeView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import SwiftUI
import Kingfisher

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
  
    // 💡 注入环境值：获取当前窗口的缩放比例，替代已弃用的 UIScreen.main.scale
  @Environment(\.displayScale) var displayScale
  
  var body: some View {
    Button(action: {
      withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)) {
        viewModel.selectedWallpaper = wallpaper
        viewModel.showDetailPage = true
          // 💡 触感反馈：点击卡片时给予轻微震动
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
      }
    }) {
        // 定义处理器：下采样至 300x500，平衡内存与清晰度
      let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 500))
      
      KFImage(URL(string: wallpaper.imageUrl))
        .placeholder {
          Rectangle()
            .fill(Color(.systemFill))
            .aspectRatio(9/16, contentMode: .fill)
        }
        .setProcessor(processor)
        // 💡 使用环境值 displayScale，确保 Retina 屏幕渲染正确
        .scaleFactor(displayScale)
        .cacheMemoryOnly()
        .fade(duration: 0.25)
        .resizable()
        .aspectRatio(contentMode: .fill)
        // --- 核心动画与装饰 ---
        .matchedGeometryEffect(id: wallpaper.id.uuidString, in: namespace)
        .cornerRadius(cornerRadius) // 重新加回圆角
        .clipped()
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4) // 恢复阴影质感
    }
    .buttonStyle(.plain)
  }
}
