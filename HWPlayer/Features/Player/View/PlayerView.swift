//
//  PlayerView.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerView: View {
    
    let store: StoreOf<Player>
    
    var body: some View {
        ZStack {
            Color.blue
            Text("PLAYER")
        }
    }
}

#Preview {
    PlayerView(
        store: .init(initialState: Player.State(), reducer: { Player() })
    )
}
