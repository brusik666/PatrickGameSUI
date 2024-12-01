//
//  ProgressBarNode.swift
//  PatrickGameSUI
//
//  Created by Brusik on 11/27/24.
//

import SpriteKit

class TimeRemainBar: SKNode {
    private let backgroundBar: SKSpriteNode
    private let foregroundBar: SKSpriteNode

    init(size: CGSize, position: CGPoint) {

        // Background Bar
        backgroundBar = SKSpriteNode(imageNamed: "asd")
        backgroundBar.size = size
        backgroundBar.anchorPoint = CGPoint(x: 0, y: 0.5)

        // Foreground Bar
        let foregroundBarScaleCoefficient: CGFloat = 0.9
        foregroundBar = SKSpriteNode(imageNamed: "äsd")
        foregroundBar.size = CGSize(width: size.width * foregroundBarScaleCoefficient, height: size.height * foregroundBarScaleCoefficient)
        foregroundBar.anchorPoint = CGPoint(x: 0, y: 0.5)

        super.init()
        self.isHidden = true
        self.position = position
        // Add bars to the node
        addChild(backgroundBar)
        addChild(foregroundBar)

        // Align bars properly
        backgroundBar.position = CGPoint(x: -size.width / 2, y: 0)
        foregroundBar.position = CGPoint(x: -size.width / 2, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Function to animate progress reduction over time
    func startTimer(over timeInterval: TimeInterval) {
        resetTimer()
        isHidden = false
        let action = SKAction.resize(toWidth: 0, duration: timeInterval)
        let completionAction = SKAction.run { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isHidden = true
        }
        let sequence = SKAction.sequence([action, completionAction])
        foregroundBar.run(sequence)
    }
    
    private func resetTimer() {
        foregroundBar.removeAllActions() // Stop any ongoing animations
        foregroundBar.size.width = backgroundBar.size.width * 0.9 // Reset to original size
    }
}
