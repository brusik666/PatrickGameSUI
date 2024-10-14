
import Foundation
import AVFoundation
import UIKit

class SoundsService {
    private init() {}
    
    static let shared = SoundsService()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    var sfxplayer: AVAudioPlayer?
    var sfx2player: AVAudioPlayer?
    private (set) var volume: Float = 0.5
    private (set) var sfxVolume: Float = 0.8
    var idleVolume: Float = 1 {
        didSet {
            sfxplayer?.volume = idleVolume
        }
    }
    var rideVolume: Float = 0.6 {
        didSet {
            sfx2player?.volume = rideVolume
        }
    }
    
    func setMusicVolume(_ volume: Float) {
        self.volume = volume
        backgroundMusicPlayer?.volume = self.volume
    }
    
    func setSFXvolume(_ volume: Float) {
        sfxVolume = volume
    }
    
    func stopPlayBackgroundMusic() {
        backgroundMusicPlayer = nil
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "theme", withExtension: "wav") else { return }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.volume = volume / 1.5
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    func shot() {
        if Game.shared.vibration {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            generator.prepare()
        }
    }
    
    func playBottleCrackSound() {
        guard let url = Bundle.main.url(forResource: "bottleCrack", withExtension: "wav") else { return }
        do {
            sfx2player = try AVAudioPlayer(contentsOf: url)
            sfx2player?.volume = sfxVolume
            sfx2player?.play()
        } catch {
            print(error)
        }
    }
    
    func playSuccessSound() {
        guard let url = Bundle.main.url(forResource: "victory1", withExtension: "mp3") else { return }
        do {
            sfxplayer = try AVAudioPlayer(contentsOf: url)
            sfxplayer?.volume = sfxVolume
            sfxplayer?.play()
        } catch {
            print(error)
        }
    }
    
    func stopAllGameSounds() {
        sfxplayer = nil
        sfx2player = nil
        //backgroundMusicPlayer = nil
    }
    
    func stopSFXPlayer() {
        sfxplayer = nil
        sfx2player = nil
    }

    
    func playWinSound() {
        guard let url = Bundle.main.url(forResource: "victory1", withExtension: "mp3") else { return }
        do {
            sfx2player = try AVAudioPlayer(contentsOf: url)
            sfx2player?.volume = sfxVolume
            sfx2player?.play()
        } catch {
            print(error)
        }
    }
    
    func playLoseSound() {
        guard let url = Bundle.main.url(forResource: "loseSound", withExtension: "wav") else { return }
        do {
            sfx2player = try AVAudioPlayer(contentsOf: url)
            sfx2player?.volume = sfxVolume
            sfx2player?.play()
        } catch {
            print(error)
        }
    }
    
    func playCarIDLESound() {
        guard let url = Bundle.main.url(forResource: "engineIdle", withExtension: "wav") else { return }
        do {
            sfxplayer = try AVAudioPlayer(contentsOf: url)
            sfxplayer?.volume = sfxVolume * 2
            sfxplayer?.numberOfLoops = -1
            sfxplayer?.play()
        } catch {
            print(error)
        }
    }
    
    func playCarRideSound() {
        guard let url = Bundle.main.url(forResource: "engineRide", withExtension: "wav") else { return }
        do {
            sfx2player = try AVAudioPlayer(contentsOf: url)
            sfx2player?.volume = sfxVolume / 1.3
            sfx2player?.numberOfLoops = -1
            sfx2player?.play()
        } catch {
            print(error)
        }
    }
    
    func playButtonClickSound() {
        guard let url = Bundle.main.url(forResource: "buttonClick", withExtension: "mp3") else { return }
        do {
            sfxplayer = try AVAudioPlayer(contentsOf: url)
            sfxplayer?.volume = sfxVolume
            sfxplayer?.play()
        } catch {
            print(error)
        }
    }
    
    func playGetBonusSound() {
        guard let url = Bundle.main.url(forResource: "bonus", withExtension: "wav") else { return }
        do {
            sfxplayer = try AVAudioPlayer(contentsOf: url)
            sfxplayer?.volume = sfxVolume
            sfxplayer?.play()
        } catch {
            print(error)
        }
    }
}
