  //
  //  WallpaperDeatilView.swift
  //  WallpaperCollections
  //
  //  Created by silverhand on 3/28/26.
  //
import SwiftUI
import Kingfisher

struct WallpaperDetailView: View {
  let wallpaper: Wallpaper
  @ObservedObject var viewModel: HomeViewModel
  let namespace: Namespace.ID
  
  @State private var isSaving = false
  @State private var showStatus = false
  @State private var statusMessage = ""
  
    // 💡 震动反馈生成器，提前实例化以减少延迟
  private let feedbackGenerator = UINotificationFeedbackGenerator()
  
  var body: some View {
    ZStack {
        // 层级 1: 纯黑背景 + 点击返回手势
      Color.black
        .ignoresSafeArea()
        .onTapGesture { dismissDetail() }
      
        // 层级 2: 主图展示
      KFImage(URL(string: wallpaper.imageUrl))
        .placeholder {
          ProgressView()
            .controlSize(.large)
            .tint(.white)
        }
        .onSuccess { _ in
            // 成功加载后给一个微弱的物理反馈
          UISelectionFeedbackGenerator().selectionChanged()
        }
        .resizable()
        .aspectRatio(contentMode: .fit)
        .matchedGeometryEffect(id: wallpaper.id.uuidString, in: namespace)
        .gesture(
          DragGesture().onEnded { value in
            if value.translation.height > 100 { dismissDetail() }
          }
        )
      
        // 层级 3: UI 控件层 (返回按钮 & 保存按钮)
      VStack {
          // 顶部返回按钮
        HStack {
          Button(action: { dismissDetail() }) {
            Image(systemName: "xmark.circle.fill")
              .font(.system(size: 32))
              .foregroundColor(.white.opacity(0.5))
          }
          Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 25)
        
        Spacer()
        
          // 底部保存按钮
        Button(action: { downloadAndSaveImage() }) {
          HStack(spacing: 12) {
            if isSaving {
              ProgressView().tint(.white)
            } else {
              Image(systemName: "square.and.arrow.down")
              Text("保存至相册")
            }
          }
          .font(.system(size: 17, weight: .semibold))
          .foregroundColor(.white)
          .padding(.vertical, 14)
          .padding(.horizontal, 30)
          .background(BlurView(style: .systemThinMaterialDark).cornerRadius(28))
          .overlay(
            RoundedRectangle(cornerRadius: 28)
              .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
          )
        }
        .padding(.bottom, 50)
        .disabled(isSaving)
      }
      
        // 层级 4: 状态提示 (Toast)
      if showStatus {
        VStack {
          Spacer()
          Text(statusMessage)
            .font(.system(size: 14, weight: .medium))
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
              VisualEffectView(
                effect: UIBlurEffect(style: .systemUltraThinMaterialDark)
              )
            )
            .foregroundColor(.white)
            .clipShape(Capsule())
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .padding(.bottom, 120)
        }
      }
    }
      // 💡 沉浸式：进入详情页时隐藏状态栏
    .statusBar(hidden: true)
  }
  
    // MARK: - Logic Functions
  
  private func dismissDetail() {
    withAnimation(
      .interactiveSpring(
        response: 0.5,
        dampingFraction: 0.8,
        blendDuration: 0.5
      )
    ) {
      viewModel.showDetailPage = false
      viewModel.selectedWallpaper = nil
    }
  }
  
    /// 💡 优化后的保存逻辑：直接从 Kingfisher 缓存提取
  private func downloadAndSaveImage() {
    isSaving = true
    
      // 预准备震动，降低体感延迟
    feedbackGenerator.prepare()
    
    let cache = ImageCache.default
      // 既然页面已经显示了图，缓存里肯定有这这张原图
    cache.retrieveImage(forKey: wallpaper.imageUrl) { result in
      DispatchQueue.main.async {
        switch result {
          case .success(let value):
            if let image = value.image {
              let saver = ImageSaver()
              saver.successHandler = {
                self.feedbackGenerator.notificationOccurred(.success)
                finishSaving(message: "已保存至相册")
              }
              saver.errorHandler = { error in
                self.feedbackGenerator.notificationOccurred(.error)
                finishSaving(message: "保存失败: \(error.localizedDescription)")
              }
              saver.writeToPhotoAlbum(image: image)
            } else {
                // 兜底逻辑：如果缓存意外丢失，则尝试重新下载
              reDownloadImage()
            }
          case .failure:
            finishSaving(message: "缓存提取失败")
        }
      }
    }
  }
  
  private func reDownloadImage() {
    guard let url = URL(string: wallpaper.imageUrl) else { return }
    URLSession.shared.dataTask(with: url) { data, _, _ in
      if let data = data, let image = UIImage(data: data) {
        let saver = ImageSaver()
        saver.successHandler = { finishSaving(message: "已保存至相册") }
        saver.writeToPhotoAlbum(image: image)
      } else {
        finishSaving(message: "下载失败")
      }
    }.resume()
  }
  
  private func finishSaving(message: String) {
    self.statusMessage = message
    self.isSaving = false
    withAnimation(.spring()) { self.showStatus = true }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      withAnimation { self.showStatus = false }
    }
  }
}

  // MARK: - UI Components

struct VisualEffectView: UIViewRepresentable {
  var effect: UIVisualEffect?
  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView()
  }
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = effect
  }
}

struct BlurView: UIViewRepresentable {
  var style: UIBlurEffect.Style
  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
