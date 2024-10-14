

class DependencyFactory {
    static func createSceneUICreator(type: SceneType) -> SceneUICreator {
        switch type {
        case .gameScene: return GameSceneUICreator()
        default: break
        //case .fireFightingScene: return FireFightingSceneUISCreator()
        }
    }
    
    static func createSceneTouchHandler(type: SceneType) -> SceneTouchHandler {
        switch type {
        case .gameScene: return GameSceneTouchHandler()
        //case .fireFightingScene: return FireFightingSceneTouchHandler()
        default: break
        }
    }
    
    static func createSceneContactHandler(type: SceneType) -> SceneContactHandler {
        switch type {
        case .gameScene: return GameSceneContactHandler()
        //case .fireFightingScene: return FireFightingSceneContactHandler()
        default: break
        }
    }
    
    
}

enum SceneType {
    case gameScene
    //case fireFightingScene
}
