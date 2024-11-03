//
//  CollectableComponent.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/31/24.
//

import Foundation
import GameplayKit

enum CollectableType {
    case coin
    case powerUp(PowerUpType)
}

class CollectableComponent: GKComponent {
    
    private var collected: Bool = false
    private let type: CollectableType
    
    init(type: CollectableType) {
        self.type = type
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collect() {
        guard !collected,
              let spriteNode = entity?.component(ofType: SpriteComponent.self)?.node,
              let gameScene = spriteNode.scene as? GameScene else { return }
        
        collected = true
        spriteNode.physicsBody = nil
        
        switch type {
        case .coin:
            gameScene.playerData.collectCoin()
        case .powerUp(let powerUpType): gameScene.playerData.collectPowerUp(powerUpType)
        }
        
        if let entity = self.entity {
            gameScene.entityManager?.removeEntity(entity: entity)
        }
    }
}
