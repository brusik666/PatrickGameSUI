//
//  DependencyFactory.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import Foundation

class DependencyFactory {
    static func createSceneUICreator(type: SceneType) -> SceneUICreator {
        switch type {
        case .gameScene: return GameSceneUICreator()
        default: break
        }
    }
    
   /* static func createSceneTouchHandler(type: SceneType) -> SceneTouchHandler {
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
    }*/
    
    static func createEntityManager(scene: GameScene) -> EntityManager {
        return EntityManager(scene: scene)
    }
    
    
}

enum SceneType {
    case gameScene
    //case fireFightingScene
}
