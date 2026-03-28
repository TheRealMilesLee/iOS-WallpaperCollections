  //
  //  ProfileView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import SwiftUI

struct ProfileView: View {
  var body: some View {
    NavigationView {
      VStack(spacing: 20) {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 80, height: 80)
        Button("Log In") {
            // Auth Logic
        }
        .buttonStyle(.borderedProminent)
      }
      .navigationTitle("Account")
    }
  }
}
