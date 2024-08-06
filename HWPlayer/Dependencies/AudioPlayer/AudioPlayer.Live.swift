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
            isPlaying: { await audioPlayerContainer.isPlaying },
            prepare: { try await audioPlayerContainer.prepare(with: $0) },
            play: { try await audioPlayerContainer.play() },
            seek: { await audioPlayerContainer.seek(to: $0) },
            updateRate: { await audioPlayerContainer.update(rate: $0) }
        )
    }
}

private actor AudioPlayerContainer {
    
    private var delegateProxy: AVAudioPlayerDelegateProxy?
    private var player: AVAudioPlayer?
    private var rate: Float = 1.0
    
    var currentTime: TimeInterval? {
        player?.currentTime
    }
    
    var duration: TimeInterval? {
        player?.duration
    }
    
    var isPlaying: Bool {
        player?.isPlaying ?? false
    }
    
    func prepare(with url: URL) throws {
        stop()
        
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url)
        player!.enableRate = true
        player!.rate = rate
        player!.prepareToPlay()
    }
    
    func play() async throws -> Bool {
        let stream = AsyncThrowingStream<Bool, Swift.Error> { continuation in
            do {
                guard let player = self.player else {
                    throw Error.playerIsNotReady
                }
                
                if player.isPlaying {
                    player.pause()
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
                    player.pause()
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
    
    func seek(to timeInterval: TimeInterval) {
        player?.currentTime = timeInterval
    }
    
    func update(rate: Float) {
        self.rate = rate
        player?.rate = rate
    }
    
    private func stop() {
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
