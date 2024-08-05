//
//  SelectorView.swift
//  HWPlayer
//
//  Created by Denis on 04.08.2024.
//

import SwiftUI

struct SelectorView: View {
    
    let itemImageNames: [String]

    @Binding var selectedIndex: Int
    
    @Namespace private var itemTransitionNamespace
    
    var body: some View {
        HStack(spacing: 8.0) {
            ForEach(itemImageNames.indices, id: \.self) { index in
                ZStack {
                    if selectedIndex == index {
                        Image(systemName: itemImageNames[index])
                            .foregroundStyle(.white)
                            .frame(width: 52.0, height: 52.0)
                            .background(
                                Circle()
                                    .foregroundStyle(.blue)
                            )
                            .matchedGeometryEffect(id: ItemTransitionGeometryEffectID(), in: itemTransitionNamespace)
                    } else {
                        Image(systemName: itemImageNames[index])
                            .foregroundStyle(.black)
                            .frame(width: 52.0, height: 52.0)
                    }
                }
                .contentShape(Circle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                    }
                }
            }
        }
        .background(
            Capsule()
                .stroke(.gray, lineWidth: 0.5)
                .fill(.white)
                .padding(-4.0)
        )
    }
}

private struct ItemTransitionGeometryEffectID: Hashable {}

#Preview {
    struct Preview: View {
        
        @State var index = 0
        
        var body: some View {
            SelectorView(itemImageNames: ["headphones", "text.alignleft"], selectedIndex: $index)
        }
    }
    
    return Preview()
}
