//
//  HWPlayerApp.swift
//  HWPlayer
//
//  Created by Denis on 02.08.2024.
//

import SwiftUI

@main
struct HWPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ScreenSelectionView(
                store: .init(initialState: ScreenSelection.State(), reducer: { ScreenSelection() })
            )
        }
    }
}
