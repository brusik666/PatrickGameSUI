
import SpriteKit

protocol SceneUICreator {
    func createUI()
    func setScene(_ scene: SKScene)
}

class GameSceneUICreator: SceneUICreator {
    
    private weak var scene: GameScene?
    
    func setScene(_ scene: SKScene) {
        guard let scene = scene as? GameScene else { return }
        self.scene = scene
    }
    func createUI() {
        
        addCameraToScene()
        adjustScaleAndCameraConstraints1()
        addAllLabels()
        //addBg()
        addButtons()
        addCoinsLabel()
        addCar()
        addCurrentWordNode()
        addLettersToScene()
        setAlphaForCameraElements()
        setObstacleNodes()
        fillSceneWithCoins(numCoins: 10)
        
    }
    
    private func setAlphaForCameraElements() {
        guard let gameScene = scene else { return }
        gameScene.camera?.children.forEach({$0.alpha = 0.85})
    }
    
    private func addCar() {
        guard let gameScene = scene else { return }
        let carHeight = gameScene.size.height / 15
        let carPosition = CGPoint(x: gameScene.size.width/2, y: carHeight/2)
        let car = Car(height: carHeight, position: carPosition)
        gameScene.car = car
        gameScene.addChild(car.spriteNode)
        
    }
    
    private func addCurrentWordNode() {
        guard let gameScene = scene else { return }
        let sceneWidthScaleCoefficient: CGFloat = 0.8
        let size = CGSize(width: gameScene.size.width * sceneWidthScaleCoefficient, height: gameScene.size.height / 20)
        let position = CGPoint(x: gameScene.size.width/2 - size.width/2, y: gameScene.size.height * 0.8)
        let wordProvider = WordProvider()
        let wordNode = CurrentWordNode(size: size, position: position, wordProvider: wordProvider)
        gameScene.addChild(wordNode)
        gameScene.currentWordNode = wordNode
    }
    
    private func setObstacleNodes() {
        
        guard let gameScene = scene,
              let spriteNodes = gameScene.children.filter({$0.name == UIElementsNames.obstacle.rawValue}) as? [SKSpriteNode] else { return }
        
        spriteNodes.forEach { node in
            
            node.zPosition = ZPositions.obstacles.rawValue
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height/2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.affectedByGravity = true
            node.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            node.physicsBody?.restitution = 1
            //node.physicsBody?.contactTestBitMask = PhysicsCategory.play
        }
    }

    
    private func addBg() {
        
        guard let gameScene = scene else { return }
        
        let bgName = "gameBG"
        let texture = SKTexture(imageNamed: bgName)
        let position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
        let bg = SpriteBuilder()
            .setTexture(texture)
            .setSize(gameScene.size)
            .setPosition(position)
            .setZPosition(ZPositions.bg.rawValue)
            .build()
        gameScene.addChild(bg)
    }
    
    private func addLettersToScene() {
        
        guard let gameScene = scene else { return }
        var currentWord = gameScene.currentWordNode.word
        print(currentWord)
        let letterSpots = gameScene.children.filter({$0.name == UIElementsNames.letterSpot.rawValue})
        letterSpots.map({$0.position}).forEach { letterPosition in
            
            let letterNode = LetterNode(height: gameScene.size.height/20, letterValue: String(currentWord.removeFirst()))
            letterNode.position = letterPosition
            gameScene.addChild(letterNode)
        }
        
        
    }

    
    private func adjustScaleAndCameraConstraints1() {
        guard let gameScene = scene else { return }
        let width: CGFloat = 390
        let height: CGFloat = 844
        //422 195
        let scaleX = width / gameScene.size.width
        let scaleY = height / gameScene.size.height

        gameScene.camera?.run(.scaleX(to: scaleX, duration: 0))
        gameScene.camera?.run(.scaleY(to: scaleY, duration: 0))

        gameScene.camera?.position = CGPoint(x: gameScene.size.width / 2 * scaleX, y: gameScene.size.height / 2 * scaleY)
        
    }


    private func addCoinsLabel() {
        guard let gameScene = scene else { return }
        
        let label = SKLabelNodeWithSprite(text: String(GameSettings.shared.dailyCoins), spriteImageName: "coinLabel", spriteHeight: gameScene.size.height/20)
        label.position = CGPoint(x: gameScene.size.width/2 - label.spriteNode.size.width, y: gameScene.size.height/2 - label.spriteNode.size.height * 2)
        label.name = UIElementsNames.coinLabel.rawValue
        gameScene.camera?.addChild(label)
    }
    
    private func addHomeButton() {
        guard let gameScene = scene else { return }
        let buttonName = UIElementsNames.homeButton.rawValue
        let texture = SKTexture(imageNamed: buttonName)
        let buttonHeigh = gameScene.size.height/20
        let position = CGPoint(x: gameScene.size.width/2 - buttonHeigh , y: -gameScene.size.height/2 + buttonHeigh * 1.5)
        let button = SpriteBuilder()
            .setTexture(texture)
            .setZPosition(ZPositions.cameraElements.rawValue)
            .setSizeByHeight(buttonHeigh)
            .setPosition(position)
            .setName(buttonName)
            .build()
        gameScene.camera?.addChild(button)
    }

    
    private func addButtons() {
        addHomeButton()
        addRemovePathButton()
        addFollowPathButton()
    }
    
    private func addRemovePathButton() {
        guard let gameScene = scene else { return }
        let buttonName = UIElementsNames.removePathButton.rawValue
        let texture = SKTexture(imageNamed: buttonName)
        let buttonHeigh = gameScene.size.height/20
        let position = CGPoint(x: gameScene.size.width/2 - buttonHeigh , y: -gameScene.size.height/2 + buttonHeigh * 2.5)
        let button = SpriteBuilder()
            .setTexture(texture)
            .setZPosition(ZPositions.cameraElements.rawValue)
            .setSizeByHeight(buttonHeigh)
            .setPosition(position)
            .setName(buttonName)
            .build()
        gameScene.camera?.addChild(button)
    }
    
    private func addFollowPathButton() {
        guard let gameScene = scene else { return }
        let buttonName = UIElementsNames.followPathButton.rawValue
        let texture = SKTexture(imageNamed: buttonName)
        let buttonHeigh = gameScene.size.height/20
        let position = CGPoint(x: gameScene.size.width/2 - buttonHeigh , y: -gameScene.size.height/2 + buttonHeigh * 3.5)
        let button = SpriteBuilder()
            .setTexture(texture)
            .setZPosition(ZPositions.cameraElements.rawValue)
            .setSizeByHeight(buttonHeigh)
            .setPosition(position)
            .setName(buttonName)
            .build()
        button.isUserInteractionEnabled = true
        gameScene.camera?.addChild(button)
    }

    func fillSceneWithCoins(numCoins: Int) {
        guard let scene else { return }
        let coinHeight: CGFloat = scene.size.width / 15
        var randomPositions: [CGPoint] = []

        
        for _ in 1...numCoins {
            let coinNode = NodeFactory.createCoinNode(height: coinHeight)
            let minDistanceBetweenCoins = coinNode.size.width/2
            let minX = CGFloat(0)
            let maxX = CGFloat(scene.size.width)
            let minY = CGFloat(0)
            let maxY = CGFloat(scene.size.height)
            
            var randomPosition: CGPoint
            var isOverlapping = false
            
            repeat {
                randomPosition = CGPoint(x: CGFloat.random(in: minX...maxX), y: CGFloat.random(in: minY...maxY))
                
                isOverlapping = false
                for existingPosition in randomPositions {
                    let distance = sqrt(pow(randomPosition.x - existingPosition.x, 2) + pow(randomPosition.y - existingPosition.y, 2))
                    if distance < minDistanceBetweenCoins {
                        isOverlapping = true
                        break
                    }
                }
            } while isOverlapping
            
            randomPositions.append(randomPosition)
            coinNode.position = randomPosition
            scene.addChild(coinNode)
        }
        
    }


    

    
    private func addMainLabel() {
        guard let gameScene = scene else { return }
        let label = RoundedLabelNode(text: "")
        label.isHidden = true
        label.position = .zero
        gameScene.mainLabel = label
        gameScene.camera?.addChild(label)
    }
    
    private func addAllLabels() {
        addMainLabel()
    }
    private func addCameraToScene() {
        guard let gameScene = scene else { return }
        let camera = SKCameraNode()
        
        
        //camera.setScale(1)
        gameScene.camera = camera
        gameScene.addChild(camera)
        //camera.position = CGPoint(x: gameScene.size.width/2, y: gameScene.size.height/2)
    }
}
