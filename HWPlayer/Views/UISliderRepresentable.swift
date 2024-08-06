//
//  UISliderRepresentable.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import SwiftUI

struct UISliderRepresentable<Value>: UIViewRepresentable where Value : BinaryFloatingPoint, Value.Stride : BinaryFloatingPoint {
    
    @Binding var value: Value?
    @Binding var maximumValue: Value?
    let onEditingChanged: (Bool) -> Void
    let sliderProvider: (UISlider) -> Void
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        sliderProvider(slider)
        slider.value = Float(value ?? 0.0)
        slider.maximumValue = Float(maximumValue ?? 0.0)
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged),
            for: .valueChanged
        )
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(self.value ?? 0.0)
        uiView.maximumValue = Float(self.maximumValue ?? 0.0)
    }
    
    func makeCoordinator() -> Coordinator {
        .init(value: $value, onEditingChanged: onEditingChanged)
    }
}

extension UISliderRepresentable {
    
    final class Coordinator: NSObject {
        
        @Binding private var value: Value?
        private let onEditingChanged: (Bool) -> Void
        
        init(value: Binding<Value?>, onEditingChanged: @escaping (Bool) -> Void) {
            self._value = value
            self.onEditingChanged = onEditingChanged
        }
        
        @objc fileprivate func valueChanged(_ sender: UISlider, _ event: UIEvent) {
            value = Value(sender.value)
            switch event.allTouches?.first?.phase {
            case .began:
                onEditingChanged(true)
            case .ended, .cancelled:
                onEditingChanged(false)
            default:
                break
            }
        }
    }
}

#Preview {
    struct Preview: View {
        
        @State var value: Double? = 3.0
        
        var body: some View {
            UISliderRepresentable(
                value: $value,
                maximumValue: .constant(10.0),
                onEditingChanged: { _ in },
                sliderProvider: { _ in }
            )
        }
    }
    
    return Preview()
}
