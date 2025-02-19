//
//  Injector.swift
//  Apple
//
//  Created by Ben Fowler on 19/2/2025.
//
import Foundation

final class Injector {
    static let shared = Injector()
    private var registerMap: [ObjectIdentifier: (Injector) -> Any] = [:]
    private var resolveMap: [ObjectIdentifier: Any] = [:]

    private init() {}

    func register<T>(_ type: T.Type, block: @escaping (Injector) -> T) {
        registerMap[ObjectIdentifier(type)] = block
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)
        // Looks up the instance generator for the given key
        guard let factory = registerMap[key] else {
            return nil
        }
        // Attempts to create the instance
        guard let newService = factory(self) as? T else {
            return nil
        }

        // Stores the instance in our "resolveMap" map
        resolveMap[key] = newService
        // Returns the new service
        return newService
    }
}
