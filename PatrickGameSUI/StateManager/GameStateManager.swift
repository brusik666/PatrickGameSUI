import SpriteKit

class GameStateManager {
    static let shared = GameStateManager()
    
    var currentState: GameState?
    
    private init() {}
    
    func transition(to state: GameState, scene: GameScene) {
        // Clean up previous state
        currentState?.exitState(scene: scene)
        
        // Set new state
        currentState = state

        
        // Enter new state
        currentState?.enterState(scene: scene)
        
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        currentState?.update(deltaTime: deltaTime, scene: scene)
    }

}

enum GameStates {
    case preInitial, initial, gameStarted, gameFinished, bird
}
