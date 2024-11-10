//
//  EntityManager.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import GameplayKit
import SpriteKit

protocol EntityController {
    func addEntity(entity: GKEntity)
    func removeEntity(entity: GKEntity)
    func update(_ deltaTime: TimeInterval)
    var player: Player? {get set}
}

class EntityManager: EntityController {
    
    lazy var componentSystems: [GKComponentSystem] = {
        let spriteSystem = GKComponentSystem(componentClass: SpriteComponent.self)
        let playerMovementSystem = GKComponentSystem(componentClass: PlayerMovementComponent.self)
        let jumpSystem = GKComponentSystem(componentClass: JumpComponent.self)
        let explosionComponent = GKComponentSystem(componentClass: ExplosionComponent.self)
        return [spriteSystem, playerMovementSystem, jumpSystem, explosionComponent]
    }()
    
    private var entities = Set<GKEntity>()
    private var entitiesToRemove = Set<GKEntity>()
    private weak var scene: GameScene?
    var player: Player?
    
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.entities.contains(entity) else { return }
            print("SOSI")
            if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
                spriteNode.removeFromParent()
            }
            print("XYU")
            self.entities.remove(entity)
            self.entitiesToRemove.insert(entity)
        }
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
