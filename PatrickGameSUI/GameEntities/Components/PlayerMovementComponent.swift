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
    
    enum MovementState {
        case normal, speedUp, slowDown
    }
    
    private var entityNode: SKSpriteNode?
    private var movementForce: CGVector
    private var maxVelocity: CGFloat
    private var speedMultiplier: CGFloat
    private var movementState: MovementState
    
    init(movementForce: CGVector, maxVelocity: CGFloat) {
        self.movementForce = movementForce
        self.maxVelocity = maxVelocity
        self.speedMultiplier = 1.0
        self.movementState = .normal
        super.init()
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()

        if let node = entity?.component(ofType: SpriteComponent.self)?.node {
            self.entityNode = node
            self.entityNode?.physicsBody?.linearDamping = 0.1
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
        guard movementState == .normal else { return }
        movementState = .speedUp
        
        //speedMultiplier = 5.0
        //print("SPEED UP")
        
        guard let sprite = entityNode,
              let physicsBody = sprite.physicsBody else { return }
        physicsBody.applyImpulse(CGVector(dx: 10000, dy: 0))
        dashWithTrail(scene: entityNode!.scene!, runTextures: [])
         Task {
             await resetSpeedAfterDelay()
         }
    }
    
    
    func slowDown() {
        guard movementState == .normal else { return }
        movementState = .slowDown
        speedMultiplier = 0.3
        //print("SLOW DOWN")
        Task {
            await resetSpeedAfterDelay()
        }
    }
    
    private func resetSpeedAfterDelay() async {
        try? await Task.sleep(nanoseconds: 500_000_000)
        resetSpeed()
    }
    
    
    
    
    private func resetSpeed() {
        speedMultiplier = 1.0
        movementState = .normal
    }
    
    private func move() {
        guard let node = entityNode, let physicsBody = node.physicsBody else { return }
        guard movementState == .normal || movementState == .slowDown else { return }
            
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
    
    func createDashTrail(texture: SKTexture, scene: SKScene) {
        // Create a trail node with the current texture
        let trailNode = SKSpriteNode(texture: texture)
        trailNode.position = entityNode!.position
        trailNode.size = entityNode!.size
        trailNode.zPosition = entityNode!.zPosition - 1 // Place it behind the player
        scene.addChild(trailNode)

        // Apply fade and scale actions for the trail effect
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let scaleDown = SKAction.scale(to: 0.5, duration: 0.5)
        let remove = SKAction.removeFromParent()
        let trailEffect = SKAction.sequence([SKAction.group([fadeOut, scaleDown]), remove])

        // Run the trail effect
        trailNode.run(trailEffect)
    }

    // Trigger the dash trail effect in your update or action logic
    func dashWithTrail(scene: SKScene, runTextures: [SKTexture]) {
        let dashDuration = 0.5
        let dashSpeed: CGFloat = 500

        // Dash action
        let dashAction = SKAction.moveBy(x: dashSpeed * CGFloat(dashDuration), y: 0, duration: dashDuration)

        // Add a repeating trail effect during the dash
        let trailInterval: TimeInterval = 0.1
        let trailAction = SKAction.repeat(SKAction.sequence([
            SKAction.run {
                // Capture the player's current texture from the run animation
                if let currentTexture = self.entityNode!.texture {
                    self.createDashTrail(texture: currentTexture, scene: scene)
                }
            },
            SKAction.wait(forDuration: trailInterval)
        ]), count: Int(dashDuration / trailInterval))

        // Run the dash and trail actions in parallel
        self.entityNode!.run(SKAction.group([dashAction, trailAction]))
    }

}
