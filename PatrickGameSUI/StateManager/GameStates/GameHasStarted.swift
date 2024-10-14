import SpriteKit

class GameHasStartedState: GameState {

    func enterState(scene: GameScene) {
        scene.portals.forEach({$0.startSpawningMonsters()})
    }
    
    func exitState(scene: GameScene) {
        //
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        scene.monsters.forEach({$0.update()})
        scene.player.update()
    }
    
    
}

