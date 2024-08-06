//
//  PlayerState.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import Foundation
import ComposableArchitecture

extension Player {
    
    @ObservableState
    struct State: Equatable {
        
        var book: Book!
        var currentKeypointIndex = 0
        
        var currentTime: TimeInterval?
        var duration: TimeInterval?
        var isPlaying = false
    }
}

extension Player.State {
    
    var currentKeypoint: KeyPoint {
        book.keyPoints[currentKeypointIndex]
    }
    
    var currentTimeString: String {
        currentTime?.formattedTimeString ?? "--:--"
    }
    
    var durationString: String {
        duration?.formattedTimeString ?? "--:--"
    }
}

// MARK: - External declarations

private extension TimeInterval {
    
    var formattedTimeString: String {
        Duration
            .milliseconds(self * 1000.0)
            .formatted(.time(pattern: .minuteSecond))
    }
}
