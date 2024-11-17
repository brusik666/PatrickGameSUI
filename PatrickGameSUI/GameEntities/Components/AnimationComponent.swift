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
            let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.05))
            animations[key] = action

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
    
}
