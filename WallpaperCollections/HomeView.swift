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
            .navigationTitle("The Collection")
            .background(Color(.systemGroupedBackground))
            // 添加刷新按钮，方便调试
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.fetchWallpapers() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct WallpaperCard: View {
    let wallpaper: Wallpaper
    let cornerRadius: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // SwiftUI 3+ 的异步图片加载
            AsyncImage(url: URL(string: wallpaper.imageUrl)) { phase in
                switch phase {
                case .empty:
                    // 1. 占位状态：核心是保持宽高比！
                    Color(.systemFill)
                        .aspectRatio(wallpaper.aspectRatio, contentMode: .fit)
                        .cornerRadius(cornerRadius)
                        
                case .success(let image):
                    // 2. 加载成功
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit) // 必须是 .fit 才能保持其原始比例
                        .cornerRadius(cornerRadius)
                        .transition(.opacity.animation(.default)) // 淡淡的渐变动画
                        
                case .failure(_):
                    // 3. 加载失败
                    VStack {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.largeTitle)
                        Text("Load Failed")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(wallpaper.aspectRatio, contentMode: .fit) // 保持比例
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(cornerRadius)
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            // 作者信息
            Text(wallpaper.author)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .padding(.horizontal, 6)
                .padding(.bottom, 4)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
