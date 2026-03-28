//
//  Untitled.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

enum Tab: String, CaseIterable {
    case home = "Home"
    case browse = "Browse"
    case search = "Search"
    case person = "Person"
    
    // 映射对应的图标 (SF Symbols)
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .browse: return "folder.fill"
        case .search: return "magnifyingglass"
        case .person: return "person.fill"
        }
    }
}

