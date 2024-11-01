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

        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            self.entityNode = node
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //move()
    }
    
    func stopPlayer() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        
        physicsBody.velocity = CGVector(dx: 0, dy: 0)
        physicsBody.angularVelocity = 0
    }
    
    
    func increaseSpeed() {
        speedMultiplier = 2.0
        print("SPEED UP")
    }
    
    
    func slowDown() {
        speedMultiplier = 0.5
        print("SLOW DOWN")
    }
    
    
    func resetSpeed() {
        speedMultiplier = 1.0
    }
    
    private func move() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        let scaledForce = CGVector(dx: movementForce.dx * speedMultiplier, dy: movementForce.dy)
        if physicsBody.velocity.dx < maxVelocity * speedMultiplier {
            physicsBody.applyForce(scaledForce)
        }
        
        if physicsBody.velocity.dx > maxVelocity * speedMultiplier {
            physicsBody.velocity.dx = maxVelocity * speedMultiplier
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
