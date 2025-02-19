//
//  ImageDownloader.swift
//  Apple
//
//  Created by Ben Fowler on 19/2/2025.
//

import UIKit
import Combine

struct ImageURL {
    let path: String
    let width: CGFloat
    let height: CGFloat
}

protocol ImageDownloading {
    func fetch(from url: URL) -> AnyPublisher<UIImage?, Never>
}

class ImageDownloader: ImageDownloading {

    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch(from url: URL) -> AnyPublisher<UIImage?, Never> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .replaceError(with: UIImage.checkmark)
            .eraseToAnyPublisher()
    }
}
