//
//  GameSceneContactHandler.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/26/24.
//

import Foundation
import SpriteKit

protocol SceneContactHandler {
    func takeContact(contact: SKPhysicsContact)
    func endContact(contact: SKPhysicsContact)
    func setScene(_ scene: SKScene)
}

class GameSceneContactHandler: SceneContactHandler {
    
    private weak var scene: GameScene?
    
    func setScene(_ scene: SKScene) {
        guard let scene = scene as? GameScene else { return }
        self.scene = scene
    }
    
    func takeContact(contact: SKPhysicsContact) {
        guard let gameScene = scene else { return }
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.obstacles, categoryB: PhysicsCategory.player) {
            
            guard let playerYPosition = bodies.bodyB.node?.position.y,
                  contact.contactPoint.y < playerYPosition else { return }
            gameScene.entityManager?.player?.component(ofType: JumpComponent.self)?.landed()
            
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.player, categoryB: PhysicsCategory.coin) {
            
            if let entity = bodies.bodyB.node?.entity,
               let collectableComponent = entity.component(ofType: CollectableComponent.self) {
                collectableComponent.collect()
            }
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.meteor, categoryB: PhysicsCategory.obstacles) {
            if let meteorEntity = bodies.bodyA.node?.entity as? Meteor,
               let explosionComponent = meteorEntity.component(ofType: ExplosionComponent.self) {
                guard meteorEntity.isExploidable else { return }
                explosionComponent.exploid {
                    DispatchQueue.main.async {
                        //self.scene?.entityManager?.removeEntity(entity: meteorEntity)
                        if let currentState = GameStateManager.shared.currentState as? InitialState {
                            currentState.meteorDropper.removeMeteor(meteorEntity)
                            print("METEOR REMOVED FROM CONTACT")
                        }
                    }
                }
                /*Task {
                    await explosionComponent.exploid()
                    //await scene?.entityManager?.removeEntity(entity: entity)
                    if let currentState = GameStateManager.shared.currentState as? InitialState {
                        currentState.meteorDropper.removeMeteor(meteorEntity)
                    }
                }*/
            }
        }
        
        /*if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.meteor, categoryB: PhysicsCategory.meteorSensor) {
            guard let meteorEntity = bodies.bodyA.node?.entity as? Meteor else { return }
            if let currentState = GameStateManager.shared.currentState as? InitialState {
                currentState.meteorDropper.removeMeteor(meteorEntity)
                print("METEOR REMOVED FROM SENSOR")
            }
        }*/
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.meteorSensor, categoryB: PhysicsCategory.meteorSensor) {
            
        }
    
    }


    func endContact(contact: SKPhysicsContact) {
        guard let gameScene = scene else { return }
    }
    
    
    private func hasContact(contact: SKPhysicsContact, categoryA: UInt32, categoryB: UInt32) -> (bodyA: SKPhysicsBody, bodyB: SKPhysicsBody)? {
        
        let bodyA: SKPhysicsBody = contact.bodyA
        let bodyB: SKPhysicsBody = contact.bodyB
        if (bodyA.categoryBitMask == categoryA && bodyB.categoryBitMask == categoryB) {
            return (bodyA, bodyB)
        }
        if (bodyA.categoryBitMask == categoryB && bodyB.categoryBitMask == categoryA) {
            return (bodyB, bodyA)
        }
        return nil
    }
}
