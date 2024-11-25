//
//  DependencyFactory.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import Foundation
import SpriteKit

class DependencyFactory {
    static func createSceneUICreator(type: SceneType) -> SceneUICreator {
        switch type {
        case .gameScene: return GameSceneUICreator()
        default: break
        }
    }
    
    static func createSceneTouchHandler(type: SceneType) -> SceneTouchHandler {
        switch type {
        case .gameScene: return GameSceneTouchHandler()
        default: break
        }
    }
    
    static func createSceneContactHandler(type: SceneType) -> SceneContactHandler {
        switch type {
        case .gameScene: return GameSceneContactHandler()
        default: break
        }
    }
    
    static func createEntityManager(scene: GameScene) -> EntityController {
        let entityStorage = EntityStorage()
        return EntityManager(scene: scene, entityContainer: entityStorage)
    }
    
    static func createMeteorDropper(scene: GameScene) -> MeteorDroppingService {
        return MeteorDropper(scene: scene, meteorTypes: [.bigMeteor, .mediumMeteor, .smallMeteor], dropInterval: 0.35, maxMeteors: 50)
    }
    
    static func createPointsCounter() -> PointsCounter {
        return GamePointsCounter()
    }
    
    
}

enum SceneType {
    case gameScene
    //case fireFightingScene
}
