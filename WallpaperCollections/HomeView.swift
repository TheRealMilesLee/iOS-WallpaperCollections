//
//  HomeView.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import SwiftUI

struct HomeView: View {
    // 观察 ViewModel 的变化
    @StateObject private var viewModel = HomeViewModel()
    
    // 物理参数定义
    let spacing: CGFloat = 12
    let cornerRadius: CGFloat = 16
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView("Fetching Art...")
                        .padding(.top, 100)
                } else {
                    // 使用 HStack 实现两列
                    HStack(alignment: .top, spacing: spacing) {
                        
                        // --- 左列 ---
                        LazyVStack(spacing: spacing) {
                            ForEach(viewModel.leftColumn) { wallpaper in
                                WallpaperCard(wallpaper: wallpaper, cornerRadius: cornerRadius)
                            }
                        }
                        
                        // --- 右列 ---
                        LazyVStack(spacing: spacing) {
                            ForEach(viewModel.rightColumn) { wallpaper in
                                WallpaperCard(wallpaper: wallpaper, cornerRadius: cornerRadius)
                            }
                        }
                    }
                    .padding(.horizontal, spacing)
                    .padding(.top, spacing)
                }
            }
            .refreshable {
                // 这里的 await 现在对应的是真正的异步操作
                await viewModel.fetchRealWallpapers()
            }
            .task {
                // 首次进入页面时自动加载
                await viewModel.fetchRealWallpapers()
            }
            .navigationTitle("The Collection")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct WallpaperCard: View {
    let wallpaper: Wallpaper
    let cornerRadius: CGFloat
    
    // 强制使用竖屏壁纸比例 9:16
    let targetAspectRatio: CGFloat = 9/16

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: wallpaper.imageUrl)) { phase in
                switch phase {
                case .empty:
                    // 骨架屏占位：严格保持 9:16
                    Rectangle()
                        .fill(Color(.systemFill))
                        .aspectRatio(targetAspectRatio, contentMode: .fill)
                        
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill) // 填充模式
                        .frame(minWidth: 0, maxWidth: .infinity)
                        // 这里如果不强制高度，就会变成真正的错落瀑布流
                        // 如果强制高度，就是宫格式布局
                        
                case .failure:
                    Image(systemName: "photo")
                        .aspectRatio(targetAspectRatio, contentMode: .fill)
                @unknown default:
                    EmptyView()
                }
            }
            .clipped() // 剪裁掉超出比例的部分
            .cornerRadius(cornerRadius)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
