  //
  //  DataModel.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import Foundation

struct Wallpaper: Identifiable, Codable, Hashable {
  var id: UUID = UUID()
  let imageUrl: String
  let author: String
    // 在真实 API 中，这些是由服务器返回的。这里我们手动模拟一下
  let width: CGFloat
  let height: CGFloat
    
    // 计算属性：用于布局引擎
  var aspectRatio: CGFloat {
    return width / height
  }
}

struct GitHubContent: Codable, Identifiable {
  var id: String { path }
  
  let name: String
  let path: String
  let type: String // "dir" 或 "file"
  let download_url: String?
}
