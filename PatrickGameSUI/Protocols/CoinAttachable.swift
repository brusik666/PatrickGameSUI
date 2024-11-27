//
//  CoinAttachable.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/16/24.
//

import SpriteKit

protocol CoinAttachable {
    func addCoinsAcrossObstacle(coinHeight: CGFloat, scene: GameScene)
}

extension CoinAttachable where Self: SKNode {
    func addCoinsAcrossObstacle(coinHeight: CGFloat, scene: GameScene) {
        guard let obstacleWidth = self.calculateObstacleWidth() else { return }
        
        
        let gap = coinHeight * 2
        let totalSpacing = coinHeight + gap
        
        // Calculate the number of coins that fit with the defined gaps
        let numberOfCoins = Int(obstacleWidth / totalSpacing)
        
        // Calculate the starting X position for centering
        let startX = -CGFloat(numberOfCoins - 1) * totalSpacing / 2
        
        for i in 0..<numberOfCoins {
            let coinPosition = CGPoint(x: startX + CGFloat(i) * totalSpacing, y: coinHeight)
            let coin = EntitiesFactory.createCoinEntity(height: coinHeight, position: coinPosition)

            scene.entityManager?.addEntity(entity: coin)
        }
    }
    
    private func calculateObstacleWidth() -> CGFloat? {
        if let obstacleShapeNode = self as? SKSpriteNode {
            return obstacleShapeNode.size.width
        } else if let obstacleShapeNode = self as? SKShapeNode, let path = obstacleShapeNode.path {
            return path.boundingBox.width
        }
        return nil
    }
}
