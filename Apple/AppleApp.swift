//
//  AppleApp.swift
//  Apple
//
//  Created by Ben Fowler on 18/2/2025.
//

import SwiftUI

@main
struct AppleApp: App {

    private var injector = Injector.shared

    init() {
        injector.register(ImageDownloading.self) { _ in
            ImageDownloader()
        }
    }

    var body: some Scene {
        WindowGroup {
            ImageList(urls: (1...4).map { ImageURL(path:  "https://picsum.photos/id/\($0)/300", width: 300, height: 300) })
        }
    }
}
