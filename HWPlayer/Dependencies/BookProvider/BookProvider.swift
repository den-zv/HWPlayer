//
//  BookProvider.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import ComposableArchitecture

@DependencyClient
struct BookProvider {
    
    var currentBook: @Sendable () async throws -> Book = { .init(image: .init(), keyPoints: .init()) }
}

extension BookProvider: TestDependencyKey {
    
    static var previewValue: Self {
        liveValue
    }
    
    static let testValue = Self()
}

extension DependencyValues {
    
    var bookProvider: BookProvider {
        get { self[BookProvider.self] }
        set { self[BookProvider.self] = newValue }
    }
}
