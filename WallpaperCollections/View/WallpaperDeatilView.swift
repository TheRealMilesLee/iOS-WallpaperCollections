  //
  //  WallpaperDeatilView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //

import SwiftUI

struct WallpaperDetailView: View {
  let wallpaper: Wallpaper
  @ObservedObject var viewModel: HomeViewModel
  let namespace: Namespace.ID
    
  @State private var isSaving = false
  @State private var showStatus = false
  @State private var statusMessage = ""

  var body: some View {
    ZStack(alignment: .bottom) { // 按钮放在底部
      // 背景黑屏，带淡淡的渐变
      Color.black
        .ignoresSafeArea()
        .opacity(viewModel.showDetailPage ? 1 : 0) // 这里可以加个背景淡入动画
      
        // 全屏图片
      AsyncImage(url: URL(string: wallpaper.imageUrl)) { phase in
        if case .success(let image) = phase {
          image
            .resizable()
            .aspectRatio(contentMode: .fit) // 详情页通常是 .fit
                                            // --- 核心 matchedGeometryEffect ---
                                            // ID 必须和卡片里的 AsyncImage 一致
            .matchedGeometryEffect(id: wallpaper.id.uuidString, in: namespace)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 可选：添加手势返回
      .gesture(
        DragGesture().onEnded { value in
          if value.translation.height > 100 { // 下滑返回
            withAnimation(.spring()) {
              viewModel.showDetailPage = false
              viewModel.selectedWallpaper = nil
            }
          }
        }
      )
        // 返回按钮
      Button(action: {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)) {
          viewModel.showDetailPage = false
          viewModel.selectedWallpaper = nil
        }
      }) {
        Image(systemName: "xmark.circle.fill")
          .font(.largeTitle)
          .foregroundColor(.white.opacity(0.7))
          .padding(.top, 60) // 适配刘海屏
          .padding(.leading, 20)
      }
        // 下载按钮
      Button(action: {
        downloadAndSaveImage()
      }) {
        HStack {
          if isSaving {
            ProgressView().tint(.white)
          } else {
            Image(systemName: "square.and.arrow.down")
            Text("保存至相册")
          }
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(BlurView(style: .systemThinMaterialDark).cornerRadius(25))
        .overlay(
          RoundedRectangle(cornerRadius: 25)
            .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
      }
      .padding(.bottom, 50)
      .disabled(isSaving)
            
        // 状态提示 (Toast)
      if showStatus {
        Text(statusMessage)
          .font(.subheadline)
          .padding()
          .background(Color.black.opacity(0.7))
          .foregroundColor(.white)
          .cornerRadius(10)
          .transition(.move(edge: .top).combined(with: .opacity))
          .padding(.bottom, 120)
      }
    }
  }

    // 核心下载逻辑
  func downloadAndSaveImage() {
    guard let url = URL(string: wallpaper.imageUrl) else { return }
    isSaving = true
        
    URLSession.shared.dataTask(with: url) { data, _, _ in
      if let data = data, let image = UIImage(data: data) {
        let saver = ImageSaver()
        saver.successHandler = {
          finishSaving(message: "已保存至相册")
        }
        saver.errorHandler = { error in
          finishSaving(message: "保存失败: \(error.localizedDescription)")
        }
        saver.writeToPhotoAlbum(image: image)
      } else {
        finishSaving(message: "图片下载失败")
      }
    }.resume()
  }

  func finishSaving(message: String) {
    DispatchQueue.main.async {
      self.statusMessage = message
      self.isSaving = false
      withAnimation { self.showStatus = true }
            
        // 2秒后自动隐藏提示
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation { self.showStatus = false }
      }
    }
  }
}

struct BlurView: UIViewRepresentable {
  var style: UIBlurEffect.Style
  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}





