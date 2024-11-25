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
        let animationComponentSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let meteorDetectionComponentSystem = GKComponentSystem(componentClass: MeteorDetectionComponent.self)
        return [spriteSystem, playerMovementSystem, jumpSystem, explosionComponent, animationComponentSystem, meteorDetectionComponentSystem]
    }()
    
    private let entityContainer: EntityContainer
    private weak var scene: GameScene?
    var player: Player?
    
    init(scene: GameScene, entityContainer: EntityContainer) {
        self.scene = scene
        self.entityContainer = entityContainer
    }
}

extension EntityManager {
    func addEntity(entity: GKEntity) {
        
        Task {
            await entityContainer.add(entity: entity)
            //print("Entity added to entities: \(entity)")
            
            if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
                await scene?.addChild(spriteNode)
               // print("Entity's sprite node added to scene: \(spriteNode)")
            }

            for componentSystem in componentSystems {
                componentSystem.addComponent(foundIn: entity)
            }
        }
    }
    
    func removeEntity(entity: GKEntity) {

        Task {
            if await entityContainer.contains(entity: entity) {
                guard let spriteNode = entity.component(ofType: SpriteComponent.self)?.node  else { return }
                await spriteNode.removeFromParent()
                await entityContainer.markForRemoval(entity: entity)
            }
        }
    }
    
    func update(_ deltaTime: TimeInterval) {
        Task {
            for componentSystem in componentSystems {
                componentSystem.update(deltaTime: deltaTime)
            }
            
            for entityToRemove in await entityContainer.getEntitiesToRemove() {
                for componentSystem in componentSystems {
                    componentSystem.removeComponent(foundIn: entityToRemove)
                }
                
                await entityContainer.remove(entity: entityToRemove)
            }
        }
    }
}
