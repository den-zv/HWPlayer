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
            Color(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 243.0 / 255.0)
                .ignoresSafeArea()
            
            TabView(selection: $store.selectedIndex) {
                PlayerView(store: store.scope(state: \.player, action: \.player))
                    .tag(ScreenSelection.State.Tab.player.rawValue)
                    .ignoresSafeArea(edges: .bottom)
                KeyPointsView(store: store.scope(state: \.keyPoints, action: \.keyPoints))
                    .tag(ScreenSelection.State.Tab.keyPoints.rawValue)
                    .ignoresSafeArea(edges: .bottom)
            }
            .padding(.top, 4.0)
            
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
