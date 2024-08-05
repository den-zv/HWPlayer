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
                
            }
        }
    }
}
