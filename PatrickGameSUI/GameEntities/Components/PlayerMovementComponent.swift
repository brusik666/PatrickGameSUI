//
//  PlayerMovementComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/22/24.
//

import Foundation
import GameplayKit
import SpriteKit

class PlayerMovementComponent: GKComponent {
    
    private var entityNode: SKNode?
    private var movementForce: CGVector
    private var maxVelocity: CGFloat
    private var speedMultiplier: CGFloat
    
    init(movementForce: CGVector, maxVelocity: CGFloat) {
        self.movementForce = movementForce
        self.maxVelocity = maxVelocity
        self.speedMultiplier = 1.0
        super.init()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        print("PIZDA")

        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            self.entityNode = node
            print("ZALUPA")
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {

        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        let scaledForce = CGVector(dx: movementForce.dx * speedMultiplier, dy: movementForce.dy)
        if physicsBody.velocity.dx < maxVelocity * speedMultiplier {
            physicsBody.applyForce(scaledForce)
        }
        
        if physicsBody.velocity.dx > maxVelocity * speedMultiplier {
            physicsBody.velocity.dx = maxVelocity * speedMultiplier
        }
    }
    
    func stopPlayer() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        physicsBody.angularVelocity = 0
    }
    
    
    func increaseSpeed() {
        speedMultiplier = 2.0
    }
    
    
    func slowDown() {
        speedMultiplier = 0.5
    }
    
    
    func resetSpeed() {
        speedMultiplier = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
