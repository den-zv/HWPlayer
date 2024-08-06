//
//  PlayerActions.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import Foundation
import ComposableArchitecture

extension Player {
    
    enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        
        case viewAppeared
        case previousKeypoint
        case nextKeypoint
        case play
        
        case bookLoaded(Book)
        case preparePlayer
        case playerFailed
        case resetValues
        case currentTimeUpdated(TimeInterval?)
        case durationUpdated(TimeInterval?)
        case isPlayingUpdated(Bool)
    }
}
