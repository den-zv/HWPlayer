//
//  ScreenSelectionActions.swift
//  HWPlayer
//
//  Created by Denis on 04.08.2024.
//

import ComposableArchitecture

extension ScreenSelection {
    
    @CasePathable
    enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        
        case player(Player.Action)
        case keyPoints(KeyPoints.Action)
    }
}
