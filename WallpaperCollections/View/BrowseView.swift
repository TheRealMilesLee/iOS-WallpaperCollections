  //
  //  BrowseView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //
import SwiftUI

struct BrowseView: View {
  @StateObject private var viewModel = BrowseViewModel()
  
    // 定义网格布局：两列
  let columns = [GridItem(.flexible()), GridItem(.flexible())]
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(viewModel.categories, id: \.path) { category in
              // 点击跳转到该文件夹的瀑布流
            NavigationLink(destination: CategoryDetailView(category: category)) {
              CategoryCard(name: category.name)
            }
          }
        }
        .padding()
      }
      .navigationTitle("Browse")
      .background(Color(.systemGroupedBackground))
      .task {
        await viewModel.loadCategories()
      }
    }
  }
}

  // 极简分类卡片
struct CategoryCard: View {
  let name: String
  var body: some View {
    VStack {
      Image(systemName: "folder.fill")
        .font(.system(size: 40))
        .foregroundColor(.accentColor)
        .padding(.bottom, 8)
      Text(name)
        .font(.headline)
        .foregroundColor(.primary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, minHeight: 120)
    .background(Color(.secondarySystemGroupedBackground))
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.05), radius: 5)
  }
}
