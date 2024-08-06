//
//  ScreenSelectionReducer.swift
//  HWPlayer
//
//  Created by Denis on 04.08.2024.
//

import ComposableArchitecture

@Reducer
struct ScreenSelection {
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.player, action: \.player) {
          Player()
        }
        Scope(state: \.keyPoints, action: \.keyPoints) {
            KeyPoints()
        }
        
        Reduce { state, action in
            switch action {
            case .binding:
              return .none
                
            case .player:
                return .none
                
            case .keyPoints:
                return .none
            }
        }
    }
}
