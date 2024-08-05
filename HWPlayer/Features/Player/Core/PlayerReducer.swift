//
//  PlayerReducer.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import ComposableArchitecture

@Reducer
struct Player {
    
    @Dependency(\.bookProvider) var bookProvider
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .viewAppeared:
                return .run { send in
                    async let book = bookProvider.currentBook()
                    try? await send(.bookLoaded(book))
                }
                
            case .bookLoaded(let book):
                guard !book.keyPoints.isEmpty else {
                    return .none
                }
                state.book = book
                return .none
                
            case .previousKeypoint:
                // TODO: reset current time
                // TODO: stop prev player
                // TODO: play new player (if unpaused?)
                state.currentKeypointIndex = max(0, state.currentKeypointIndex - 1)
                return .none
                
            case .nextKeypoint:
                // TODO: reset current time
                // TODO: stop prev player
                // TODO: play new player (if unpaused?)
                state.currentKeypointIndex = min(state.book.keyPoints.count - 1, state.currentKeypointIndex + 1)
                return .none
            }
        }
    }
}
