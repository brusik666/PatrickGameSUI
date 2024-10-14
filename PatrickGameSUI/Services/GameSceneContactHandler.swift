
import Foundation
import SpriteKit

protocol SceneContactHandler {
    func takeContact(contact: SKPhysicsContact)
    func endContact(contact: SKPhysicsContact)
    func setScene(_ scene: SKScene)
}

class GameSceneContactHandler: SceneContactHandler {
    
    private weak var scene: GameScene?
    
    func setScene(_ scene: SKScene) {
        guard let scene = scene as? GameScene else { return }
        self.scene = scene
    }
    
    private func hasContact(contact: SKPhysicsContact, categoryA: UInt32, categoryB: UInt32) -> (bodyA: SKPhysicsBody, bodyB: SKPhysicsBody)? {
        
        let bodyA: SKPhysicsBody = contact.bodyA
        let bodyB: SKPhysicsBody = contact.bodyB
        if (bodyA.categoryBitMask == categoryA && bodyB.categoryBitMask == categoryB) {
            return (bodyA, bodyB)
        }
        if (bodyA.categoryBitMask == categoryB && bodyB.categoryBitMask == categoryA) {
            return (bodyB, bodyA)
        }
        return nil
    }
    
    func takeContact(contact: SKPhysicsContact) {
        guard let gameScene = scene else { return }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.player, categoryB: PhysicsCategory.monsterProjectile) {
            guard !gameScene.player.inCotactWithBullet else { return }
            bodies.bodyB.node?.removeFromParent()
            gameScene.player.spriteNode.blinkAnimation()
            gameScene.player.inCotactWithBullet = true
            let iteration: Int = gameScene.boss == nil ? 1 : 8
            for _ in 1...iteration {
                gameScene.receivedDamageNode.increaseValue()
            }
            
            gameScene.run(.sequence([.wait(forDuration: 0.15), .run {
                gameScene.player.inCotactWithBullet = false
            }]))
            
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.playerProjectile, categoryB: PhysicsCategory.monster) {
            guard let bullet = bodies.bodyA.node as? Ammo else { return }
            let target = findHitedMonster(spriteNode: bodies.bodyB.node as! SKSpriteNode, scene: gameScene)
            bullet.hit(target: target)
            
        }
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.monster, categoryB: PhysicsCategory.mine) {
            let target = findHitedMonster(spriteNode: (bodies.bodyA.node as! SKSpriteNode), scene: gameScene)
            target.takeDamage(amount: 100)
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.playerProjectile, categoryB: PhysicsCategory.obstacle) {
            bodies.bodyA.node?.removeFromParent()
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.bomb, categoryB: PhysicsCategory.monster) {
            guard let bomb = bodies.bodyA.node as? BombNode else { return }
            bomb.exploid()
            gameScene.run(.sequence([.wait(forDuration: 0.65), .run {
                bomb.removeFromParent()
            }]))
            let target = findHitedMonster(spriteNode: bodies.bodyB.node as! SKSpriteNode, scene: gameScene)
            target.takeDamage(amount: 100)
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.bomb, categoryB: PhysicsCategory.obstacle) {
            guard let bomb = bodies.bodyA.node as? BombNode else { return }
            bomb.exploid()
            gameScene.run(.sequence([.wait(forDuration: 0.65), .run {
                bomb.removeFromParent()
            }]))
            (bodies.bodyB.node as! SKSpriteNode).particleAnimation(color: .systemRed)
        }
        
        if let bodies = hasContact(contact: contact, categoryA: PhysicsCategory.monsterProjectile, categoryB: PhysicsCategory.obstacle) {
            bodies.bodyA.node?.removeFromParent()
        }
        
    }
    
    func endContact(contact: SKPhysicsContact) {
        guard let gameScene = scene else { return }
    }
    
    private func findHitedMonster(spriteNode: SKSpriteNode, scene: GameScene) ->
    DamageReceivable {
        let monstersToIterate = scene.weakMonsters + scene.strongMonsters + [scene.boss]
        return monstersToIterate.filter({$0?.spriteNode == spriteNode}).first!!
        
    }

}
