//
//  AppleTests.swift
//  AppleTests
//
//  Created by Ben Fowler on 18/2/2025.
//
import Testing
import Combine
import UIKit
import Fakery
@testable import Apple

struct AppleTests {

    @Test func imageDownloader() async throws {
        let faker = Faker()
        let mock = ImageDownloader.Mock()
        let urls = (0...10).map { _ in faker.internet.url() }

        Injector.shared.register(ImageDownloading.self) { _ in
            mock
        }

        let sut = ImageList.ViewModel()

        sut.fetchImages(urls: urls)

        #expect(mock.fromCalls.contains(urls.compactMap { URL(string: $0)}))
    }
}

extension ImageDownloader {
    class Mock: ImageDownloading {
        var fromCalls: [URL] = []
        var fetchReturn: AnyPublisher<UIImage?, Never>?
        func fetch(from url: URL) -> AnyPublisher<UIImage?, Never> {
            fromCalls.append(url)
            return fetchReturn ?? Just(nil).eraseToAnyPublisher()
        }
    }
}

