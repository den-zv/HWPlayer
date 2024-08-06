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
        
        var seekState: SeekState = .inactive
        var rate: Rate = .normal
        
        var errorOccured = false
    }
}

extension Player.State {
    
    enum SeekState: Equatable {
        
        case inactive
        case active(wasPlaying: Bool)
    }
    
    enum Rate: Float, Equatable {
        
        case normal = 1.0
        case fast = 1.5
        case doubled = 2.0
        
        var title: String {
            switch self {
            case .normal:
                return "x1"
            case .fast:
                return "x1.5"
            case .doubled:
                return "x2"
            }
        }
        
        mutating func switchToNext() {
            switch self {
            case .normal:
                self = .fast
            case .fast:
                self = .doubled
            case .doubled:
                self = .normal
            }
        }
    }
    
    var currentKeypoint: KeyPoint {
        book.keyPoints[currentKeypointIndex]
    }
    
    var currentTimeString: String {
        currentTime?.formattedTimeString ?? "--:--"
    }
    
    var durationString: String {
        duration?.formattedTimeString ?? "--:--"
    }
    
    var areActionsDisabled: Bool {
        currentTime == nil || errorOccured
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
