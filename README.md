# Oura

> **Oura** (v1.0.0) —— 一个基于 GitHub 资产分发协议的高性能壁纸采集与归档系统。

[](https://developer.apple.com/ios/)
[](https://www.google.com/search?q=https://developer.apple.com/xcode/swiftui/)
[](https://www.google.com/search?q=LICENSE)

## 0x01 项目哲学 (Philosophy)

**Oura** 不仅仅是一个壁纸 App，它是对“有序审美”的工程化实践。其内核逻辑遵循以下三条准则：

1.  **结构自洽**：从 GitHub 远程仓库（Source）到本地相册（Sink）的全链路自动化。
2.  **复杂度可控**：通过 Kingfisher 二级缓存与 Downsampling 协议，在 120Hz 下维持低熵内存占用。
3.  **理性美学**：遵循 Material Design 3 演进规范，采用 0px 硬边缘几何结构与深色域配色（\#121212 / \#00D2FF）。

## 0x02 技术栈 (Tech Stack)

  * **UI Framework**: SwiftUI (Declarative UI)
  * **Image Engine**: [Kingfisher](https://github.com/onevcat/Kingfisher) (Prefetching & Downsampling)
  * **Architecture**: MVVM + Repository Pattern
  * **Haptics**: UIImpactFeedback (Core Interaction)
  * **Animation**: MatchedGeometryEffect (Non-linear transitions)

## 0x03 核心特性 (Features)

  * **[Performance] 工业级缓存管理**：自动处理网络解压，支持离线预览，针对 4K 原图进行显存优化。
  * **[Interaction] 沉浸式交互**：支持下滑返回手势、状态栏动态隐藏以及物理级触感确认。
  * **[Security] 权限沙盒**：基于 PHPhotoLibrary 的权限自动检查逻辑，确保写入安全。
  * **[Design] 2026 Aesthetic**：深色模式原生适配，AccentColor 全局着色，支持 iOS 26 桌面着色图标。

## 0x04 快速开始 (Setup)

```bash
# 1. 克隆仓库
git clone https://github.com/miles/oura.git

# 2. 打开项目
cd oura
open Oura.xcodeproj

# 3. 依赖安装
# 项目使用 Swift Package Manager (SPM) 自动管理 Kingfisher
```

## 0x05 路线图 (Roadmap)

  - [x] 基于 GitHub 仓库的 API 解析
  - [x] 瀑布流下采样性能调优 (OOM Fix)
  - [x] Material Design 3 风格图标设计
  - [ ] 接入本地 CoreData 收藏夹
  - [ ] 支持壁纸 Exif 元数据解析显示

## 0x06 关于作者 (Author)

**Miles (Hengyi Li)**
*DevOps Engineer | Structural Rationalist | System Architect*

"Bridging servers and sunsets, navigating between kernels and existence."
