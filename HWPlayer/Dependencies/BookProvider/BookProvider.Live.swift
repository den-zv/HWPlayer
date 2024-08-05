//
//  BookProvider.Live.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import Dependencies
import UIKit.UIImage

extension BookProvider: DependencyKey {
    
    static var liveValue: Self {
        // TODO: 12313 check is it called only once
        let inMemoryBookProvider = InMemoryBookProvider()
        return Self(
            currentBook: { try await inMemoryBookProvider.book() }
        )
    }
}

private actor InMemoryBookProvider {
    
    enum Error: Swift.Error {
        
        case imageIsMissing
        case audioFileIsMissing
    }
    
    func book() throws -> Book {
        guard let data = UIImage(named: "")?.pngData() else {
            throw Error.imageIsMissing
        }
        
        return try .init(
            imageData: data,
            keyPoints: [
                .init(
                    title: "Alice was beginning to get wery tired of sitting by her sister on the bank",
                    audioResourceName: "Alice_1"
                ),
                .init(
                    title: "\"Curiouser and curiouser!\" cried Alice.",
                    audioResourceName: "Alice_2"
                ),
                .init(
                    title: "They were indeed a queer-looking party that assembled on the bank",
                    audioResourceName: "Alice_3"
                ),
                .init(
                    title: "It was the White Rabbit, trotting slowly back again",
                    audioResourceName: "Alice_4"
                ),
                .init(
                    title: "The Caterpillar and Alice looked at each other for some time in silence",
                    audioResourceName: "Alice_5"
                )
            ]
        )
    }
}

private extension KeyPoint {
    
    init(title: String, audioResourceName: String) throws {
        id = .init()
        self.title = title
        guard let url = Bundle.main.url(forResource: "Alice_1", withExtension: "m4a") else {
            throw InMemoryBookProvider.Error.audioFileIsMissing
        }
        audioURL = url
    }
}
