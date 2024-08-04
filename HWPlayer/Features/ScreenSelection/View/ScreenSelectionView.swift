//
//  ScreenSelectionView.swift
//  HWPlayer
//
//  Created by Denis on 04.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct ScreenSelectionView: View {
    
    @Bindable var store: StoreOf<ScreenSelection>
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $store.selectedIndex) {
                PlayerView(store: store.scope(state: \.player, action: \.player))
                    .tag(ScreenSelection.State.Tab.player.rawValue)
                    .ignoresSafeArea()
                KeyPointsView(store: store.scope(state: \.keyPoints, action: \.keyPoints))
                    .tag(ScreenSelection.State.Tab.keyPoints.rawValue)
                    .ignoresSafeArea()
            }
            
            SelectorView(itemImageNames: ["headphones", "text.alignleft"], selectedIndex: $store.selectedIndex)
                .padding(.bottom, 8.0)
        }
    }
}

#Preview {
    ScreenSelectionView(
        store: .init(initialState: ScreenSelection.State(), reducer: { ScreenSelection() })
    )
}
