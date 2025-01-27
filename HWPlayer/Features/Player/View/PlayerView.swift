//
//  PlayerView.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerView: View {
    
    @Bindable var store: StoreOf<Player>
    
    var body: some View {
        ZStack {
            Color(red: 255.0 / 255.0, green: 248.0 / 255.0, blue: 243.0 / 255.0)
            
            if store.book == nil {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.blue)
            } else {
                GeometryReader { geometryProxy in
                    VStack(spacing: 0.0) {
                        coverImage
                            .frame(height: geometryProxy.heightAligned(340.0))
                            .padding(.top, geometryProxy.heightAligned(40.0))
                            .padding(.horizontal, 40.0)
                        
                        keyPoint
                            .padding(.top, geometryProxy.heightAligned(36.0))
                            .padding(.horizontal, 44.0)
                        
                        slider
                            .padding(.horizontal, 16.0)
                            .padding(.top, geometryProxy.heightAligned(20.0))
                        
                        speedControl
                            .padding(.top, geometryProxy.heightAligned(20.0))
                        
                        playbackControls
                            .padding(.top, geometryProxy.heightAligned(48.0))
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            store.send(.viewAppeared)
        }
    }
}

// MARK: - Subviews

private extension PlayerView {
    
    @ViewBuilder
    var coverImage: some View {
        Image(uiImage: store.book.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder
    var keyPoint: some View {
        VStack(spacing: 10.0) {
            Text("KEY POINT \(store.currentKeypointIndex + 1) OF \(store.book.keyPoints.count)")
                .font(.system(size: 14.0, weight: .semibold))
                .foregroundStyle(.gray)
            Text(store.currentKeypoint.title)
                .font(.system(size: 16.0))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .frame(height: 44.0)
        }
    }
    
    @ViewBuilder
    var slider: some View {
        HStack(spacing: 8.0) {
            HStack(spacing: 0.0) {
                Spacer()
                Text(store.currentTimeString)
                    .font(.system(size: 14.0))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 1.0)
            }
            .frame(width: 40.0)
            
            UISliderRepresentable(
                value: $store.currentTime,
                maximumValue: $store.duration,
                onEditingChanged: {
                    store.send(.sliderEditingChanged($0))
                },
                sliderCreateProvider: {
                    let configuration = UIImage.SymbolConfiguration(pointSize: 18.0)
                    let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
                    $0.setThumbImage(image, for: .normal)
                },
                sliderUpdateProvider: {
                    let readyColor = UIColor(red: 0.0 / 255.0, green: 102.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
                    let erroneousColor = UIColor.red
                    let color = store.errorOccured ? erroneousColor : readyColor
                    $0.minimumTrackTintColor = color
                    $0.tintColor = color
                }
            )
            .disabled(store.areActionsDisabled)
            
            HStack(spacing: 0.0) {
                Text(store.durationString)
                    .font(.system(size: 14.0))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 1.0)
                Spacer()
            }
            .frame(width: 40.0)
        }
    }
    
    @ViewBuilder
    var speedControl: some View {
        Button(
            action: {
                store.send(.changeRate)
            },
            label: {
                Text("Speed \(store.rate.title)")
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
                    store.send(.previousKeypoint)
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
                    store.send(.seekBackward10)
                },
                label: {
                    Image(systemName: "gobackward.10")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            .disabled(store.areActionsDisabled)
            Button(
                action: {
                    store.send(.play)
                },
                label: {
                    Image(systemName: store.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(.black)
                        .font(.system(size: 44.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            .padding(.horizontal, 6.0)
            .disabled(store.areActionsDisabled)
            Button(
                action: {
                    store.send(.seekForward15)
                },
                label: {
                    Image(systemName: "goforward.15")
                        .foregroundStyle(.black)
                        .font(.system(size: 28.0))
                }
            )
            .frame(width: 44.0, height: 44.0)
            .disabled(store.areActionsDisabled)
            Button(
                action: {
                    store.send(.nextKeypoint)
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

// MARK: - External declarations

private extension GeometryProxy {
    
    func heightAligned(_ height: CGFloat) -> CGFloat {
        size.height * height / 844.0
    }
}

// MARK: - Preview

#Preview {
    PlayerView(
        store: .init(initialState: Player.State(), reducer: { Player() })
    )
}
