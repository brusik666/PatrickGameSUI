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
        addCombinationProgressBarToScene()
        addAllLabels()
        
        
    }
    
    private func addAllLabels() {
        addMainLabel()
        addCoinsLabel()
        addMessageLabel()
    }
    
    private func addMainLabel() {
        guard let gameScene = scene,
              let evasionTimerBar = gameScene.evasionTimerBar else {
            print("There is no existing evasionTimerBar!")
            return
        }
        let label = RoundedLabelNode(text: "", fontColor: .purple, fontSize: 35)
        label.isHidden = false
        label.position = CGPoint(
            x: evasionTimerBar.position.x,
            y: evasionTimerBar.position.y + 30
        )
        gameScene.mainLabel = label
        gameScene.camera?.addChild(label)
    }
    
    private func addMessageLabel() {
        guard let gameScene = scene else { return }
        let label = RoundedLabelNode(text: "", fontColor: .systemPink, fontSize: 25)
        label.isHidden = true
        label.position = .zero
        gameScene.messageLabel = label
        gameScene.camera?.addChild(label)
    }
    
    private func addCombinationProgressBarToScene() {
        guard let gameScene = scene else { return }
        
        let barSize = CGSize(width: gameScene.size.width * 0.2, height: gameScene.size.height * 0.07)
        let barPosition = CGPoint(x: -gameScene.size.width / 2 + barSize.width, y: gameScene.size.height / 3)
        let timeRemainBar = TimeRemainBar(size: barSize, position: barPosition)
        timeRemainBar.zPosition = ZPositions.cameraElements.rawValue
        gameScene.camera?.addChild(timeRemainBar)
        gameScene.evasionTimerBar = timeRemainBar
    }
    
    private func addCoinsLabel() {
        guard let gameScene = scene else { return }
        
        let coinsAmount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.playerCoins.rawValue)
        let label = SKLabelNodeWithSprite(text: String(coinsAmount), spriteImageName: "coin", spriteHeight: gameScene.size.height/14)
        label.position = CGPoint(x: gameScene.size.width/2 - label.spriteNode.size.width * 2, y: gameScene.size.height/2 - label.spriteNode.size.height * 2)
        label.name = "coinLabel"
        label.zPosition = 5
        gameScene.camera?.addChild(label)
        
    }
    
    private func addObstacleBlock() {
        guard let gScene = scene else { return }
        let positionX = gScene.frame.midX
        let size1 = CGSize(width: gScene.size.width * 30, height: gScene.size.height / 10)

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
        largeObstacle.physicsBody?.friction = 0.2
        largeObstacle.position = CGPoint(x: positionX * 15, y: 0)
        
        gScene.addChild(largeObstacle)
        largeObstacle.addCoinsAcrossObstacle(coinHeight: 35, scene: scene!)
    }


    
    private func addBackgroundToScene() {
        guard let gameScene = scene else { return }
        let bgTextureName = ImageName.Backgrounds.background.rawValue
        let bgTexture = SKTexture(imageNamed: bgTextureName)
        let bgWidth = bgTexture.size().width
        
        for i in 0..<50 {
            let background = SpriteBuilder()
                .setTexture(bgTexture)
                .setSize(CGSize(width: bgWidth, height: gameScene.size.height)) // Set the width of each background sprite
                .setPosition(CGPoint(x: CGFloat(i) * bgWidth, y: gameScene.size.height / 2)) // Tile backgrounds horizontally
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
        let camera = CustomCamera()
        camera.configure(baseOffset: CGPoint(x: gameScene.size.width / 10, y: gameScene.size.height / 10), smoothingFactor: 0.1)
        //camera.constraints = constraints
        camera.setScale(1)
        gameScene.camera = camera
        gameScene.addChild(camera)
        camera.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
    }
}
