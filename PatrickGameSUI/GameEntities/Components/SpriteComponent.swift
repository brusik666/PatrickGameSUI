//
//  SpriteComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let node: SKSpriteNode
    
    init(texture: SKTexture, height: CGFloat, position: CGPoint = .zero) {
        node = SpriteBuilder<SKSpriteNode>()
            .setPosition(position)
            .setTexture(texture)
            .setSizeByHeight(height)
            .setZPosition(5)
            .build()
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
