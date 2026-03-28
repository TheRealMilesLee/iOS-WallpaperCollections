//
//  Service.swift
//  WallpaperCollections
//
//  Created by silverhand on 3/28/26.
//

import Foundation

class GitHubService {
    let owner = "TheRealMilesLee"
    let repo = "The-Wallpaper-Collection"
    let branch = "master" // 确认你的分支名是 main 还是 master

    func fetchAllImages(path: String = "") async throws -> [Wallpaper] {
        // 1. 必须请求 GitHub API 才能拿到 JSON 列表
        // 注意对 path 进行编码，处理空格
        let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/contents/\(encodedPath)"
        
        guard let url = URL(string: urlString) else { return [] }
        
        let request = URLRequest(url: url)
        // 提示：如果你请求频繁，建议在这里加上你的 GitHub Personal Access Token
        // request.setValue("token YOUR_TOKEN", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 检查状态码，如果是 403 大概率是 API Rate Limit 到了
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
            print("GitHub API 限速了，请稍后再试或添加 Token")
            return []
        }

        let contents = try JSONDecoder().decode([GitHubContent].self, from: data)
        var images: [Wallpaper] = []
        
        for item in contents {
            if item.type == "dir" {
                // 递归获取子目录（建议先只取一层，防止仓库太大撑爆内存）
                if path.isEmpty { // 仅限第一层递归
                    let subImages = try await fetchAllImages(path: item.path)
                    images.append(contentsOf: subImages)
                }
            } else if item.type == "file" && isImage(name: item.name) {
                // 2. 核心替换逻辑：将 GitHub 的下载地址换成 jsDelivr 加速地址
                // 原地址: raw.githubusercontent.com/...
                // 目标地址: cdn.jsdelivr.net/gh/TheRealMilesLee/The-Wallpaper-Collection@main/path/to/image.jpg
                
                let cdnUrl = "https://cdn.jsdelivr.net/gh/\(owner)/\(repo)@\(branch)/\(item.path)"
                let encodedCdnUrl = cdnUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                images.append(Wallpaper(
                    imageUrl: encodedCdnUrl,
                    author: "Miles",
                    width: 1600,
                    height: 900
                ))
            }
        }
        return images
    }
    
    private func isImage(name: String) -> Bool {
        let extensions = [".jpg", ".jpeg", ".png", ".heic", ".webp"]
        return extensions.contains { name.lowercased().hasSuffix($0) }
    }
}
