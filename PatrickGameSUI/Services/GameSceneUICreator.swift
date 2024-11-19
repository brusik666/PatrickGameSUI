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
        
        //addBackgroundToScene()
        addObstacleBlock()
        addCameraToScene()
        addMeteorRoomNode()
        addAllLabels()
        
    }
    
    private func addAllLabels() {
        addMainLabel()
        addCoinsLabel()
    }
    
    private func addMainLabel() {
        guard let gameScene = scene else { return }
        let label = RoundedLabelNode(text: "")
        label.isHidden = true
        label.position = .zero
        gameScene.mainLabel = label
        gameScene.camera?.addChild(label)
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
        var positionX = gScene.frame.midX
        let size = CGSize(width: gScene.size.width * 0.45, height: gScene.size.height / 10)
        let size1 = CGSize(width: gScene.size.width * 10, height: gScene.size.height / 10)
        let screenHeight = gScene.size.height

        // Create a large obstacle at a fixed position
        let largeObstacle = ObstaclesWithCoins(imageNamed: "onstacle")
        largeObstacle.size = size1
        largeObstacle.zPosition = 5
        largeObstacle.physicsBody = SKPhysicsBody(rectangleOf: size1)
        largeObstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
        largeObstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
        largeObstacle.physicsBody?.affectedByGravity = false
        largeObstacle.physicsBody?.isDynamic = false
        largeObstacle.physicsBody?.restitution = 0
        largeObstacle.position = CGPoint(x: positionX * 5, y: 0)
        gScene.addChild(largeObstacle)

        // Create multiple obstacles with coins
        [-1, 1].forEach { screenOffset in
            switch screenOffset {
            case -1: positionX *= 1.2
            case 0: positionX += 1
            case 1: positionX *= 0.5
            default: break
            }
            (0...50).forEach { index in
                let obstacle = ObstaclesWithCoins(imageNamed: "obstacle")
                obstacle.size = size
                obstacle.zPosition = 5
                obstacle.physicsBody = SKPhysicsBody(rectangleOf: size)
                obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
                obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.player
                obstacle.physicsBody?.affectedByGravity = false
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.restitution = 0
                obstacle.position = CGPoint(
                    x: positionX + CGFloat(index) * gScene.size.width,
                    y: CGFloat(screenOffset) * screenHeight * 0.8
                )

                // Optionally add coins to the obstacle
                let coinSize = CGSize(width: 20, height: 20) // Adjust as needed
                let coinImageName = "coin" // Replace with your coin asset name
                //obstacle.addCoinsAcrossObstacle(coinSize: coinSize, entityManager: gScene.entityManager as! EntityManager)
                
                gScene.addChild(obstacle)
            }
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
        //let constraints = [
          //  SKConstraint.positionY(SKRange(lowerLimit: gameScene.frame.midY))
        //]
        let camera = SKCameraNode()
        //camera.constraints = constraints
        camera.setScale(0.5)
        gameScene.camera = camera
        gameScene.addChild(camera)
        camera.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
    }
    
    private func addMeteorRoomNode() {
        guard let gameScene = scene,
              let cameraNode = gameScene.camera else { return }
        let roomNodeSize = CGSize(width: gameScene.size.width * 1.1, height: gameScene.size.height * 1.1)
        let meteorRoomNode = MeteorRoomNode(imageNamed: "xyu")
        meteorRoomNode.name = "meteorRoomNode"
        meteorRoomNode.isHidden = false
        meteorRoomNode.size = roomNodeSize
        cameraNode.addChild(meteorRoomNode)
    }

}
