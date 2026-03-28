  //
  //  WallpaperCollectionsApp.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import SwiftUI
import SwiftData
import Kingfisher

@main
struct WallpaperCollectionsApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Item.self,
    ])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false
    )

    do {
      return try ModelContainer(
        for: schema,
        configurations: [modelConfiguration]
      )
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  init() {
      // 1. 限制内存缓存为 100MB，防止后台闪退
    ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
      // 2. 限制磁盘缓存为 1GB，保持系统整洁
    ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
      // 3. 设置缓存过期时间为 7 天
    ImageCache.default.diskStorage.config.expiration = .days(7)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}
