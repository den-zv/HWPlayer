//
//  PlayerActions.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import ComposableArchitecture

extension Player {
    
    enum Action {
        
        case viewAppeared
        case bookLoaded(Book)
        
        case previousKeypoint
        case nextKeypoint
    }
}
