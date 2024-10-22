import SpriteKit

class GameHasStartedState: GameState {

    func enterState(scene: GameScene) {
        showRightPass(scene: scene) {
            switch Game.shared.currentLevel {
            case 4:
                self.startTimer(scene: scene)
                fallthrough
            case 3:
                self.spawnBombs(scene: scene)
                fallthrough
            case 2:
                self.spawnMonsters(scene: scene)
            case 1:
                break
            default: break
            }
            
        }
    }
    
    func exitState(scene: GameScene) {
        //
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        //
    }
    
    private func showRightPass(scene: GameScene, completion: @escaping () -> Void) {
        
        var wait: CGFloat = 0.03
        
        scene.squaresLayer.children.forEach { node in
            let squareNode = node as! SquareNode
            squareNode.run(.sequence([
                .wait(forDuration: wait),
                .run {
                    squareNode.changeTexture()
                    squareNode.children.forEach({$0.isHidden = false})
                },
                .wait(forDuration: CGFloat(Game.shared.currentLevel + 1)),
                .run {
                    squareNode.changeTexture()
                    squareNode.children.forEach({$0.isHidden = true})
                }
            ]))
            wait += 0.015
        }
        completion()
    }
    
    private func spawnMonsters(scene: GameScene) {
        let xPos = scene.size.width * 1.2
        let monsterHeight = scene.player.spriteNode.size.height
        scene.run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run {
                let monsterType: MonsterType = Int.random(in: 1...2) == 1 ? .wolf : .bear
                let yPos = CGFloat.random(in: (scene.size.height * 0.2)...(scene.size.height * 0.8))
                let monster = Monster(type: monsterType, position: CGPoint(x: xPos, y: yPos), height: monsterHeight)
                scene.addChild(monster.spriteNode)
                monster.move()
            },
            .wait(forDuration: 5)
        ])))
    }
    
    
    private func startTimer(scene: GameScene) {
        let secondsToCount = 150
        var seconds = secondsToCount
        scene.mainLabel.text = ""
        scene.mainLabel.position.y = scene.size.width * 0.85
        scene.mainLabel.isHidden = false
        scene.mainLabel.run(.repeat(.sequence([
            .wait(forDuration: 1),
            .run {
                scene.mainLabel.text = String(seconds)
                if seconds == 0 {
                    GameStateManager.shared.transition(to: GameHasFinishedState(isWin: false), scene: scene)
                }
                seconds -= 1
            }
        ]), count: secondsToCount + 1))
    }
    
    private func spawnBombs(scene: GameScene) {
        let xPos = scene.size.width * 1.2
        let bombHeight = scene.player.spriteNode.size.height / 1.5
        scene.run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run {
                let texture = SKTexture(imageNamed: "bomb")
                let yPos = CGFloat.random(in: (scene.size.height * 0.2)...(scene.size.height * 0.8))
                let bombNode = SpriteBuilder<BombNode>()
                    .setTexture(texture)
                    .setSizeByHeight(bombHeight)
                    .setZPosition(ZPositions.monster.rawValue)
                    .setPosition(CGPoint(x: xPos, y: yPos))
                    .setPhysicsBody(isDynamic: true, isTexured: true)
                    .setPhysicsCategories(mask: PhysicsCategory.bomb, collision: [PhysicsCategory.player], contact: [PhysicsCategory.player])
                    .build()
                scene.addChild(bombNode)
                bombNode.physicsBody?.applyImpulse(CGVector(dx: CGFloat.random(in: -5000...(-1000)), dy: 0))
            },
            .wait(forDuration: 1.5)
        ])))
    }
    
    
    
}

