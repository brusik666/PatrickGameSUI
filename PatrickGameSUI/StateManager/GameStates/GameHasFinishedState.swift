import SpriteKit

class GameHasFinishedState: GameState {
    
    var shouldCameraFollowPlayer: Bool = false
    
    let isPlayerWin: Bool
    
    init(isWin: Bool) {
        self.isPlayerWin = isWin
    }
    
    func enterState(scene: GameScene) {
        let duration: CGFloat = 1
        if isPlayerWin {
            SoundsService.shared.playWinSound()
        } else {

            SoundsService.shared.playLoseSound()
        }
        scene.run(.sequence([.wait(forDuration: duration), .run {
            scene.gameOverDelegate?.gameOver(victory: self.isPlayerWin)
            SoundsService.shared.stopAllGameSounds()
        }]))
        
    }
    
    func exitState(scene: GameScene) {
        //
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        //
    }
    
    
}
