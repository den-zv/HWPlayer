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
        case sliderEditingChanged(Bool)
        case seekBackward10
        case seekForward15
        case changeRate
        
        case bookLoaded(Book)
        case preparePlayer
        case playerFailed
        case pause
        case resetValues
        case seek(TimeInterval)
        
        case currentTimeUpdated(TimeInterval?)
        case durationUpdated(TimeInterval?)
        case isPlayingUpdated(Bool)
        case seekStateUpdated(Player.State.SeekState)
        case errorOccuredUpdated(Bool)
    }
}
