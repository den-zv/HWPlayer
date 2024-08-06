//
//  AudioPlayer.swift
//  HWPlayer
//
//  Created by Denis on 06.08.2024.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct AudioPlayer {
    
    var currentTime: @Sendable () async -> TimeInterval?
    var duration: @Sendable () async -> TimeInterval?
    var isPlaying: @Sendable () async -> Bool = { false }
    var prepare: @Sendable (_ url: URL) async throws -> Void
    var play: @Sendable () async throws -> Bool
}

extension AudioPlayer: TestDependencyKey {
    
    static var previewValue: Self {
        let isPlaying = LockIsolated(false)
        let currentTime = LockIsolated(0.0)
        let duration = LockIsolated(92.0)
        
        return Self(
            currentTime: { currentTime.value },
            duration: { duration.value },
            isPlaying: { isPlaying.value },
            prepare: { _ in
                isPlaying.setValue(false)
                currentTime.setValue(0)
            },
            play: {
                isPlaying.setValue(true)
                while isPlaying.value, currentTime.value < duration.value {
                    try await Task.sleep(for: .seconds(1))
                    currentTime.withValue { $0 += 1 }
                }
                isPlaying.setValue(false)
                currentTime.setValue(0)
                return true
            }
        )
    }
    
    static let testValue = Self()
}

extension DependencyValues {
    
    var audioPlayer: AudioPlayer {
        get { self[AudioPlayer.self] }
        set { self[AudioPlayer.self] = newValue }
    }
}
