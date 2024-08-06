//
//  PlayerReducer.swift
//  HWPlayer
//
//  Created by Denis on 05.08.2024.
//

import ComposableArchitecture

@Reducer
struct Player {
    
    @Dependency(\.bookProvider) var bookProvider
    @Dependency(\.audioPlayer) var audioPlayer
    @Dependency(\.continuousClock) var clock
    
    private enum CancellationID: Hashable {
        
        case playback
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
              return .none
                
            case .viewAppeared:
                guard state.book == nil else {
                    return .none
                }
                
                return .run { send in
                    async let book = bookProvider.currentBook()
                    try? await send(.bookLoaded(book))
                }
                
            case .previousKeypoint:
                guard state.currentKeypointIndex > 0 else {
                    return .none
                }
                state.currentKeypointIndex -= 1
                return .send(.preparePlayer)
                
            case .nextKeypoint:
                guard state.currentKeypointIndex < state.book.keyPoints.count - 1 else {
                    return .none
                }
                state.currentKeypointIndex += 1
                return .send(.preparePlayer)
                
            case .play:
                return .run { send in
                    let isPlaying = await !audioPlayer.isPlaying()
                    
                    await send(.isPlayingUpdated(isPlaying))
                    
                    if isPlaying {
                        async let playAudio: Void = if try await self.audioPlayer.play() {
                            await send(.resetValues)
                        } else {
                            await send(.playerFailed)
                        }
                        
                        for await _ in self.clock.timer(interval: .milliseconds(200)) {
                            await send(.currentTimeUpdated(audioPlayer.currentTime()))
                        }
                        
                        do {
                            try await playAudio
                        } catch {
                            await send(.playerFailed)
                        }
                        
                    } else {
                        await send(.resetValues)
                    }
                }
                .cancellable(id: CancellationID.playback)
                
            case .sliderEditingChanged(let isEditing):
                if isEditing {
                    return .run { send in
                        let isPlaying = await audioPlayer.isPlaying()
                        await send(.seekStateUpdated(.active(wasPlaying: isPlaying)))
                        await send(.pause)
                    }
                } else {
                    guard let time = state.currentTime else {
                        return .none
                    }
                    return .run { [seekState = state.seekState] send in
                        await audioPlayer.seek(time)
                        await send(.seekStateUpdated(.inactive))
                        
                        guard case .active(let wasPlaying) = seekState, wasPlaying else {
                            return
                        }
                        
                        let currentTime = await audioPlayer.currentTime() ?? 0.0
                        let duration = await audioPlayer.duration() ?? 0.0
                        
                        // handling case when scrolling straight to the end of track
                        if currentTime == 0.0, time > 0.0 {
                            await send(.resetValues)
                            return
                        }

                        await send(.play)
                    }
                }
                
            case .seekBackward10:
                return .send(.seek(-10.0))
                
            case .seekForward15:
                return .send(.seek(15.0))
                
            case .bookLoaded(let book):
                guard !book.keyPoints.isEmpty else {
                    return .none
                }
                state.book = book
                return .send(.preparePlayer)
                
            case .preparePlayer:
                return .concatenate(
                    .send(.pause),
                    .run { [url = state.currentKeypoint.audioURL] send in
                        do {
                            try await audioPlayer.prepare(url)
                            
                            await send(.resetValues)
                        } catch {
                            await send(.playerFailed)
                        }
                    }
                )
                
            case .playerFailed:
                // TODO: 12313 show error here
                return .merge(
                    .send(.pause),
                    .send(.currentTimeUpdated(nil)),
                    .send(.durationUpdated(nil)),
                    .send(.isPlayingUpdated(false))
                )
                
            case .pause:
                return .cancel(id: CancellationID.playback)
                
            case .resetValues:
                return .concatenate(
                    .send(.pause),
                    .run { send in
                        async let updateTime: Void = send(.currentTimeUpdated(audioPlayer.currentTime()))
                        async let updateDuration: Void = send(.durationUpdated(audioPlayer.duration()))
                        async let updateIsPlaying: Void = send(.isPlayingUpdated(audioPlayer.isPlaying()))
                        _ = await (updateTime, updateDuration, updateIsPlaying)
                    }
                )
                
            case .currentTimeUpdated(let currentTime):
                print(">>>>> currentTime: \(currentTime ?? -1.0)")
                state.currentTime = currentTime
                return .none
                
            case .durationUpdated(let duration):
                state.duration = duration
                return .none
                
            case .isPlayingUpdated(let isPlaying):
                state.isPlaying = isPlaying
                return .none
                
            case .seekStateUpdated(let seekState):
                state.seekState = seekState
                return .none
                
            case .seek(let delta):
                return .run { send in
                    guard let previousTime = await audioPlayer.currentTime() else {
                        await send(.resetValues)
                        return
                    }
                    await audioPlayer.seek(previousTime + delta)
                }
            }
        }
    }
}
