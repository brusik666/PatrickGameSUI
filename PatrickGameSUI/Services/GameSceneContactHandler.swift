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
            gameScene.entityManager?.player.component(ofType: JumpComponent.self)?.landed()
            
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
