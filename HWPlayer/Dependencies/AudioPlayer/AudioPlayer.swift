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
    var prepare: @Sendable (_ url: URL) async throws -> Void
    var play: @Sendable () async throws -> Bool
    var pause: @Sendable () async -> Void
    // TODO: 12313 check do we need it publicly
    var stop: @Sendable () async -> Void
}

extension AudioPlayer: TestDependencyKey {
    
    static var previewValue: Self {
        let isPlaying = LockIsolated(false)
        let currentTime = LockIsolated(0.0)
        let duration = LockIsolated(92.0)
        
        return Self(
            currentTime: { currentTime.value },
            duration: { duration.value },
            prepare: { _ in },
            play: {
                isPlaying.setValue(true)
                while isPlaying.value, currentTime.value < duration.value {
                    try await Task.sleep(for: .seconds(1))
                    currentTime.withValue { $0 += 1 }
                }
                isPlaying.setValue(false)
                currentTime.setValue(0)
                return true
            },
            pause: {
                isPlaying.setValue(false)
            },
            stop: {
                isPlaying.setValue(false)
                currentTime.setValue(0)
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
