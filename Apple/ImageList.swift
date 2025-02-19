//
//  ContentView.swift
//  Apple
//
//  Created by Ben Fowler on 18/2/2025.
//

import SwiftUI
import Combine

@MainActor
struct ImageList: View {

    @StateObject private var vm = ViewModel()
    let urls: [ImageURL]

    var body: some View {
        VStack {
            Text("Image downloader")
            List {
                ForEach(Array(vm.images.enumerated()), id: \.offset) { index, image in
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: CGFloat(urls[index].width), height: CGFloat(urls[index].height))
                            .cornerRadius(5)
                            .centered(for: .horizontal)
                    } else {
                        ProgressView()
                            .frame(width: urls[index].width, height: urls[index].height)
                            .centered(for: .horizontal)
                    }
                }
            }
        }
        .onAppear {
            vm.fetchImages(urls: urls.map(\.path))
        }
    }
}

#Preview {
    Injector.shared.register(ImageDownloading.self) { _ in
        ImageDownloader.Preview()
    }

    return ImageList(urls: (1...4).map {
        ImageURL(path: "https://picsum.photos/id/\($0)/300", width: 300, height: 300)
    })
}

extension ImageDownloader {
    class Preview: ImageDownloading {
        private var session: URLSession

        init(session: URLSession = .shared) {
            self.session = session
        }

        func fetch(from url: URL) -> AnyPublisher<UIImage?, Never> {
            session.dataTaskPublisher(for: url)
                .map(\.data)
                .compactMap { UIImage(data: $0) }
                .replaceError(with: UIImage.checkmark)
                .delay(for: .seconds(Int.random(in: 0...5)), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

