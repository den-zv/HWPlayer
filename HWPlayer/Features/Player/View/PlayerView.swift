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
    
    // TODO: 12313 remove this
    @State var playingTime = 3.0
    
    var body: some View {
        ZStack {
            Color(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 243.0 / 255.0)
            VStack(spacing: 0.0) {
                coverImage
                    .padding(.top, 40.0)
                    .padding(.horizontal, 80.0)
                
                keyPoint
                    .padding(.top, 40.0)
                    .padding(.horizontal, 44.0)
                
                slider
                    .padding(.horizontal, 16.0)
                    .padding(.top, 20.0)
                
                speedControl
                    .padding(.top, 20.0)
                
                playbackControls
                    .padding(.top, 48.0)
                
                Spacer()
            }
        }
    }
}

// MARK: - Subviews

private extension PlayerView {
    
    @ViewBuilder
    var coverImage: some View {
        Image("Alice_cover")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder
    var keyPoint: some View {
        VStack(spacing: 10.0) {
            Text("KEY POINT 2 OF 10")
                .font(.system(size: 14.0, weight: .semibold))
                .foregroundStyle(.gray)
            Text("Design is not how a thing looks, but how it works")
                .font(.system(size: 16.0))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder
    var slider: some View {
        HStack(spacing: 8.0) {
            Text("00:28")
                .font(.system(size: 14.0))
                .foregroundStyle(.gray)
                .padding(.bottom, 1.0)
            
            UISliderRepresentable(
                value: $playingTime,
                onEditingChanged: {
                    print(">>>>> onEditingChanged: \($0)")
                },
                sliderProvider: {
                    let color = UIColor(red: 0.0 / 255.0, green: 102.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
                    $0.minimumTrackTintColor = color
                    $0.tintColor = color
                    $0.maximumValue = 0.0
                    $0.maximumValue = 10.0
                    
                    let configuration = UIImage.SymbolConfiguration(pointSize: 18.0)
                    let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
                    $0.setThumbImage(image, for: .normal)
                }
            )
            
            Text("02:12")
                .font(.system(size: 14.0))
                .foregroundStyle(.gray)
                .padding(.bottom, 1.0)
        }
    }
    
    @ViewBuilder
    var speedControl: some View {
        Button(
            action: {
                print(">>>>> speed change")
            },
            label: {
                Text("Speed x1")
                    .font(.system(size: 14.0, weight: .semibold))
                    .foregroundStyle(.black)
                    .background(
                        RoundedRectangle(cornerSize: .init(width: 6.0, height: 6.0))
                            .foregroundStyle(
                                Color(red: 242.0 / 255.0, green: 235.0 / 255.0, blue: 232.0 / 255.0)
                            )
                            .padding(.horizontal, -12.0)
                            .padding(.vertical, -10.0)
                    )
            }
        )
        .padding(.horizontal, 12.0)
        .padding(.vertical, 10.0)
    }
    
    @ViewBuilder
    var playbackControls: some View {
        HStack(spacing: 18.0) {
            Button(
                action: {
                    print(">>>>> backward")
                },
                label: {
                    Image(systemName: "backward.end")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            Button(
                action: {
                    print(">>>>> backward 10")
                },
                label: {
                    Image(systemName: "gobackward.10")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            Button(
                action: {
                    print(">>>>> pause")
                },
                label: {
                    Image(systemName: "pause.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 44.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            .padding(.horizontal, 6.0)
            Button(
                action: {
                    print(">>>>> forward 15")
                },
                label: {
                    Image(systemName: "goforward.15")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            Button(
                action: {
                    print(">>>>> forward")
                },
                label: {
                    Image(systemName: "forward.end")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
        }
    }
}

#Preview {
    PlayerView(
        store: .init(initialState: Player.State(), reducer: { Player() })
    )
}
