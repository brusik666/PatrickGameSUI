//
//  AnimationComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/18/24.
//

import GameplayKit
import SpriteKit

class AnimationComponent: GKComponent {
    
    private let spriteNode: SKSpriteNode
    private var animations: [String: SKAction] = [:]
    
    init(spriteNode: SKSpriteNode, atlases: [String: SKTextureAtlas]) {
        self.spriteNode = spriteNode
        super.init()
        setupAnimations(with: atlases)
    }
    
    private func setupAnimations(with atlases: [String: SKTextureAtlas]) {
        for (key, atlas) in atlases {
            let textures = atlas.textureNames.sorted().compactMap { atlas.textureNamed($0) }
            let action1 = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.04, resize: false, restore: true))
            animations[key] = action1
        }
    }
    
    func playAnimation(named name: String) {
        guard let animation = animations[name] else {
            print("Animation \(name) not found")
            return
        }
        spriteNode.run(animation, withKey: name)
    }

    func stopAnimation() {
        spriteNode.removeAllActions()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTrailEffect() {
        // Create a trail node with the player's current texture
        guard let texture = spriteNode.texture else { return }
        let trailNode = SKSpriteNode(texture: texture)
        trailNode.position = spriteNode.position
        trailNode.size = spriteNode.size
        trailNode.zPosition = spriteNode.zPosition - 1 // Place behind the player
        trailNode.color = .black // Start with some darkness
        trailNode.colorBlendFactor = 0.3 // Light dark at the start
        spriteNode.parent?.addChild(trailNode) // Add to the same parent node

        let duration: CGFloat = 0.5 // Duration for the entire effect

        // Custom darkening effect
        let darkenAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            guard let sprite = node as? SKSpriteNode else { return }
            // Calculate the progress
            let progress = elapsedTime / duration
            // Gradually increase the darkness
            sprite.colorBlendFactor = 0.55 + (progress * 0.7) // From light dark to heavy dark
        }

        // Fade out effect
        let fadeOut = SKAction.fadeOut(withDuration: duration)

        // Remove node after effects are complete
        let remove = SKAction.removeFromParent()

        // Combine darkening, fade out, and remove actions
        let trailEffect = SKAction.sequence([SKAction.group([darkenAction, fadeOut]), remove])

        // Run the trail effect
        trailNode.run(trailEffect)
    }



    func playDashTrailEffect() {
        let trailInterval: TimeInterval = 0.05
        let dashDuration: TimeInterval = 0.5
        
        // Add a repeating trail during the dash
        let trailAction = SKAction.repeat(SKAction.sequence([
            SKAction.run { [weak self] in
                self?.createTrailEffect()
            },
            SKAction.wait(forDuration: trailInterval)
        ]), count: Int(dashDuration / trailInterval))
        
        spriteNode.run(trailAction)
    }

    
}
