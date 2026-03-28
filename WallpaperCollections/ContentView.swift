//
//  ContentView.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        MainTabView()
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
