//
//  ScreenSelection.swift
//  HWPlayer
//
//  Created by Denis on 04.08.2024.
//

import ComposableArchitecture

extension ScreenSelection {
    
    @ObservableState
    struct State: Equatable {
        
        var selectedIndex = 0
        
        var player = Player.State()
        var keyPoints = KeyPoints.State()
    }
}

extension ScreenSelection.State {
    
    var tabs: [Tab] { Tab.allCases }
}

// MARK: - Tab

extension ScreenSelection.State {
    
    enum Tab: Int, Equatable, CaseIterable {
        
        case player
        case keyPoints
    }
}
