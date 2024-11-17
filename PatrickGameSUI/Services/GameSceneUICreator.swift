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
        
        let shapeNode = SKShapeNode(rectOf: size1)
        shapeNode.physicsBody = SKPhysicsBody(rectangleOf: size1)
        shapeNode.fillColor = .brown
        shapeNode.zPosition = 4
        shapeNode.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
        shapeNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
        shapeNode.physicsBody?.affectedByGravity = false
        shapeNode.physicsBody?.isDynamic = false
        shapeNode.position = CGPoint(x: positionX * 5, y: 0)
        gScene.addChild(shapeNode)

        [-1, 1].forEach { screenOffset in
            switch screenOffset {
            case -1: positionX *= 1.2
            case 0: positionX += 1
            case 1: positionX *= 0.5
            default: break
            }
            (0...50).forEach { index in
                let shapeNode = SKShapeNode(rectOf: size)
                shapeNode.physicsBody = SKPhysicsBody(rectangleOf: size)
                shapeNode.fillColor = .brown
                shapeNode.zPosition = 4
                shapeNode.physicsBody?.categoryBitMask = PhysicsCategory.obstacles
                shapeNode.physicsBody?.contactTestBitMask = PhysicsCategory.player
                shapeNode.physicsBody?.affectedByGravity = false
                shapeNode.physicsBody?.isDynamic = false
                shapeNode.position = CGPoint(
                    x: positionX + CGFloat(index) * gScene.size.width,
                    y: CGFloat(screenOffset) * screenHeight * 0.8
                )
                gScene.addChild(shapeNode)
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
        let constraints = [
            SKConstraint.positionY(SKRange(lowerLimit: gameScene.frame.midY))
        ]
        let camera = SKCameraNode()
        camera.constraints = constraints
        camera.setScale(1.25)
        gameScene.camera = camera
        gameScene.addChild(camera)
        camera.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)
    }
    
    private func addMeteorRoomNode() {
        guard let gameScene = scene,
              let cameraNode = gameScene.camera else { return }
        let meteorRoomNode = MeteorRoomNode(sceneSize: gameScene.size)
        cameraNode.addChild(meteorRoomNode)
    }
    
    private func setupOutOfBoundsSensors() {
        
        guard let gameScene = scene,
              let cameraNode = gameScene.camera else { return }
        let offset: CGFloat = 150
        let sensorWidth: CGFloat = 30
        
        func createSensorPhysicsBody() -> SKPhysicsBody? {
            let physicBodySize = CGSize(width: gameScene.frame.width, height: sensorWidth)
            return PhysicBodyBuilder()
                .withRectangle(size: physicBodySize)
                .setIsDynamic(true)
                .setAffectedByGravity(false)
                .setMass(10000000)
                .setAllowsRotation(false)
                .setPhysicsCategories(mask: PhysicsCategory.meteorSensor, collision: [], contact: [PhysicsCategory.meteor])
                .build()
        }

        let bottomSensor = SKSpriteNode()
        bottomSensor.size = CGSize(width: gameScene.frame.width, height: sensorWidth)
        bottomSensor.texture = SKTexture(imageNamed: ImageName.Buttons.playButton.rawValue)
        bottomSensor.position = CGPoint(x: 0, y: -offset)
        bottomSensor.physicsBody = createSensorPhysicsBody()
        cameraNode.addChild(bottomSensor)
        
        let leftSensor = SKSpriteNode()
        leftSensor.size = CGSize(width: sensorWidth, height: gameScene.frame.height)
        leftSensor.texture = SKTexture(imageNamed: ImageName.Buttons.playButton.rawValue)
        leftSensor.position = CGPoint(x: -gameScene.frame.width / 2 - offset, y: 0)
        leftSensor.physicsBody = createSensorPhysicsBody()
        cameraNode.addChild(leftSensor)
        
        // Right Sensor
        let rightSensor = SKSpriteNode()
        rightSensor.size = CGSize(width: sensorWidth, height: gameScene.frame.height)
        rightSensor.texture = SKTexture(imageNamed: ImageName.Buttons.playButton.rawValue)
        rightSensor.position = CGPoint(x: gameScene.frame.width / 2 + offset, y: 0)
        rightSensor.physicsBody = createSensorPhysicsBody()
        cameraNode.addChild(rightSensor)
    }

}
