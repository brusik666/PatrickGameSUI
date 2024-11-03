//
//  GameSceneUICreator.swift
//  PatrickGameSUI
//
//  Created by Brusik on 10/16/24.
//
import SpriteKit

protocol SceneUICreator {
    func createUI()
    func setScene(_ scene: GameScene)
}

class GameSceneUICreator: SceneUICreator {
    
    weak var scene: GameScene?
    
    func setScene(_ scene: GameScene) {
        self.scene = scene
    }

    
    func createUI() {
        
        addBackgroundToScene()
        addObstacleBlock()
        addCameraToScene()
        addCoinsLabel()
        
    }
    
    private func addCoinsLabel() {
        guard let gameScene = scene else { return }
        
        let coinsAmount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.playerCoins.rawValue)
        let label = SKLabelNodeWithSprite(text: String(coinsAmount), spriteImageName: "coin", spriteHeight: gameScene.size.height/20)
        label.position = CGPoint(x: gameScene.size.width/2 - label.spriteNode.size.width * 2, y: gameScene.size.height/2 - label.spriteNode.size.height * 2)
        label.name = "coinLabel"
        label.zPosition = 5
        gameScene.camera?.addChild(label)
        
    }
    
    private func addObstacleBlock() {
        guard let gScene = scene else { return }
        let positionX = gScene.frame.midX
        let size = CGSize(width: gScene.size.width * 0.7, height: gScene.size.height / 5)
        (0...50).forEach { index in
            let shapeNode = SKShapeNode(rectOf: size)
            shapeNode.physicsBody = SKPhysicsBody(rectangleOf: size)
            shapeNode.fillColor = .brown
            shapeNode.zPosition = 4
            shapeNode.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
            shapeNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
            shapeNode.physicsBody?.affectedByGravity = false
            shapeNode.physicsBody?.isDynamic = false
            shapeNode.position = CGPoint(x: positionX + CGFloat(index) * gScene.size.width, y: 0)
            gScene.addChild(shapeNode)
        }
    }
    
    private func addBackgroundToScene() {
        guard let gameScene = scene else { return }
        let bgTextureName = ImageName.Backgrounds.background.rawValue
        let bgTexture = SKTexture(imageNamed: bgTextureName)
        for i in 1...50 {
            let background = SpriteBuilder()
                .setTexture(bgTexture)
                .setSize(gameScene.size)
                .setPosition(CGPoint(x: gameScene.frame.midX * CGFloat(i), y: gameScene.frame.midY))
                .setZPosition(1)
                .build()
            
            gameScene.addChild(background)
        }
    }

    
    private func addCameraToScene() {
        guard let gameScene = scene else { return }
        let constraints = [
            SKConstraint.positionY(SKRange(lowerLimit: gameScene.frame.midY))
        ]
        let camera = SKCameraNode()
        camera.constraints = constraints
        camera.setScale(1)
        gameScene.camera = camera
        gameScene.addChild(camera)
        camera.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
    }
    
    
}
