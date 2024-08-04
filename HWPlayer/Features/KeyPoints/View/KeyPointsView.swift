//
//  KeyPointsView.swift
//  HWKeyPoints
//
//  Created by Denis on 05.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct KeyPointsView: View {
    
    let store: StoreOf<KeyPoints>
    
    var body: some View {
        ZStack {
            Color.yellow
            Text("KEY POINTS")
        }
    }
}

#Preview {
    KeyPointsView(
        store: .init(initialState: KeyPoints.State(), reducer: { KeyPoints() })
    )
}
