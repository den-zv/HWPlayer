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
            Color(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 243.0 / 255.0)
            Text("KEY POINTS")
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    KeyPointsView(
        store: .init(initialState: KeyPoints.State(), reducer: { KeyPoints() })
    )
}
