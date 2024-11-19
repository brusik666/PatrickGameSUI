//
//  CoinAttachable.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/16/24.
//

import SpriteKit

protocol CoinAttachable {
    func addCoinsAcrossObstacle(coinSize: CGSize, coinImageName: String)
}

extension CoinAttachable where Self: SKNode {
    func addCoinsAcrossObstacle(coinSize: CGSize, coinImageName: String) {
        guard let obstacleWidth = self.calculateObstacleWidth() else { return }
        
        let coinWidth = coinSize.width
        let gap = coinWidth / 2
        let totalSpacing = coinWidth + gap
        
        // Calculate the number of coins that fit with the defined gaps
        let numberOfCoins = Int(obstacleWidth / totalSpacing)
        
        // Calculate the starting X position for centering
        let startX = -CGFloat(numberOfCoins - 1) * totalSpacing / 2
        
        for i in 0..<numberOfCoins {
            let coin = SKSpriteNode(imageNamed: coinImageName)
            coin.size = coinSize
            coin.position = CGPoint(x: startX + CGFloat(i) * totalSpacing, y: coinSize.height) // Adjust Y if needed
            self.addChild(coin)
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
