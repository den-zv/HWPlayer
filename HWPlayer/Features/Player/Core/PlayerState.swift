//
//  PlayerState.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import ComposableArchitecture

extension Player {
    
    @ObservableState
    struct State: Equatable {
        
        var book: Book!
        var currentKeypointIndex = 0
    }
}

extension Player.State {
    
    var currentKeypoint: KeyPoint {
        book.keyPoints[currentKeypointIndex]
    }
}
