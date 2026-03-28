  //
  //  TabView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //
import SwiftUI

struct MainTabView: View {
  @State private var selectedTab: Tab = .home
    
  var body: some View {
    TabView(selection: $selectedTab) {
        // 1. 主页 (我们刚才写的那个)
      HomeView()
        .tabItem {
          Label("Home", systemImage: Tab.home.icon)
        }
        .tag(Tab.home)
            
        // 2. 浏览页
      BrowseView()
        .tabItem {
          Label("Browse", systemImage: Tab.browse.icon)
        }
        .tag(Tab.browse)
            
        // 3. 搜索页
      SearchView()
        .tabItem {
          Label("Search", systemImage: Tab.search.icon)
        }
        .tag(Tab.search)
            
        // 4. 个人中心
      ProfileView()
        .tabItem {
          Label("Person", systemImage: Tab.person.icon)
        }
        .tag(Tab.person)
    }
      // 设置 AccentColor 保持你偏好的那种“工程审美”色调
    .accentColor(.primary)
  }
}
