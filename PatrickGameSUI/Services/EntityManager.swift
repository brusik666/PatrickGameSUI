//
//  EntityManager.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import GameplayKit
import SpriteKit

class EntityManager {
    
    lazy var componentSystems: [GKComponentSystem] = {
        let spriteSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let playerMovementSystem = GKComponentSystem(componentClass: PlayerMovementComponent.self)
        let jumpSystem = GKComponentSystem(componentClass: JumpComponent.self)
        return [spriteSystem, playerMovementSystem, jumpSystem]
    }()
    
    var entities = Set<GKEntity>()
    var entitiesToRemove = Set<GKEntity>()
    private weak var scene: GameScene?
    var player: Player!
    
    init(scene: GameScene) {
        self.scene = scene
    }
}

extension EntityManager {
    func addEntity(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene?.addChild(spriteNode)
            print("player added to scene")
        }

        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func removeEntity(entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        entities.remove(entity)
        entitiesToRemove.insert(entity)
    }
    
    func update(_ deltaTime: TimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for entityToRemove in entitiesToRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: entityToRemove)
            }
        }
        entitiesToRemove.removeAll()
    }
}
