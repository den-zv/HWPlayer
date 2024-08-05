//
//  AudioPlayer.Live.swift
//  HWPlayer
//
//  Created by Denis on 06.08.2024.
//

import AVFoundation
import Dependencies

extension AudioPlayer: DependencyKey {
    
    static var liveValue: Self {
        let audioPlayerContainer = AudioPlayerContainer()
        return Self(
            currentTime: { await audioPlayerContainer.currentTime },
            duration: { await audioPlayerContainer.duration },
            prepare: { try await audioPlayerContainer.prepare(with: $0) },
            play: { try await audioPlayerContainer.play() },
            pause: { await audioPlayerContainer.pause() },
            stop: { await audioPlayerContainer.stop() }
        )
    }
}

private actor AudioPlayerContainer {
    
    private var delegateProxy: AVAudioPlayerDelegateProxy?
    private var player: AVAudioPlayer?
    
    var currentTime: TimeInterval? {
        player?.currentTime
    }
    
    var duration: TimeInterval? {
        player?.duration
    }
    
    func prepare(with url: URL) throws {
        stop()
        
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url)
        player!.enableRate = true
        player!.prepareToPlay()
    }
    
    func play() async throws -> Bool {
        let stream = AsyncThrowingStream<Bool, Swift.Error> { continuation in
            do {
                guard let player = self.player else {
                    throw Error.playerIsNotReady
                }
                
                self.delegateProxy = .init(
                    audioPlayerDidFinishPlaying: { flag in
                        continuation.yield(flag)
                        continuation.finish()
                    },
                    audioPlayerDecodeErrorDidOccur: { error in
                        continuation.finish(throwing: error)
                    }
                )
                player.delegate = self.delegateProxy
                
                continuation.onTermination = { _ in
                    player.stop()
                }
                
                player.play()
            } catch {
                continuation.finish(throwing: error)
            }
        }
        
        for try await didFinish in stream {
            return didFinish
        }
        
        throw CancellationError()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
        player = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

private extension AudioPlayerContainer {
    
    enum Error: Swift.Error {
        
        case playerIsNotReady
    }
}

private final class AVAudioPlayerDelegateProxy: NSObject, AVAudioPlayerDelegate, Sendable {
    
    let audioPlayerDidFinishPlaying: @Sendable (Bool) -> Void
    let audioPlayerDecodeErrorDidOccur: @Sendable (Error?) -> Void
    
    init(
        audioPlayerDidFinishPlaying: @escaping @Sendable (Bool) -> Void,
        audioPlayerDecodeErrorDidOccur: @escaping @Sendable (Error?) -> Void
    ) {
        self.audioPlayerDidFinishPlaying = audioPlayerDidFinishPlaying
        self.audioPlayerDecodeErrorDidOccur = audioPlayerDecodeErrorDidOccur
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPlayerDidFinishPlaying(flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.audioPlayerDecodeErrorDidOccur(error)
    }
}
