//
//  ImageList+VM.swift
//  Apple
//
//  Created by Ben Fowler on 19/2/2025.
//

import SwiftUI
import Combine

// would prefer not to include swiftUI or UI objects in the viewmodel if possible
extension ImageList {
    class ViewModel: ObservableObject {
        @Published var images: [UIImage?] = []
        private var bag = Set<AnyCancellable>()
        private var imageFetcher = Injector.shared.resolve(ImageDownloading.self)!

        func fetchImages(urls: [String]) {

            images = Array(repeating: nil, count: urls.count)

            let images = urls.compactMap { URL(string: $0) }
                .enumerated()
                .map { a in
                    imageFetcher.fetch(from: a.element)
                    .map { (a.offset, $0)}
                }

            Publishers
                .MergeMany(images)
                .receive(on: DispatchQueue.main)
                .sink {
                    self.images[$0.0] = $0.1
                }
                .store(in: &bag)

        }
    }
}
