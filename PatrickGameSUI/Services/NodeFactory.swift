import SpriteKit

class NodeFactory {
    static func createMineNode(player: Player) -> MineNode {
        let mineNodeName = Game.shared.hasMineSkinBought ? UIElementsNames.mineNode1.rawValue : UIElementsNames.mineNode0.rawValue
        let texture = SKTexture(imageNamed: mineNodeName)
        let position: CGPoint = CGPoint(x: 0, y: -player.spriteNode.size.height/1.5)
        let mineNode = SpriteBuilder<MineNode>()
            .setTexture(texture)
            .setPosition(position)
            .setSizeByHeight(player.spriteNode.size.height/2.5)
            .setPhysicsBody(isDynamic: true, isTexured: true)
            .setZPosition(player.spriteNode.zPosition - 1)
            .setPhysicsCategories(mask: PhysicsCategory.mine, collision: [PhysicsCategory.monster], contact: [PhysicsCategory.monster])
            .build()
        return mineNode
        
    }
    
    static func createBombNode(player: Player) -> BombNode {
        let bombNodeName = Game.shared.hasBombSkinBought ? UIElementsNames.bombNode1.rawValue : UIElementsNames.bombNode0.rawValue
        let texture = SKTexture(imageNamed: bombNodeName)
        let position: CGPoint = CGPoint(x: 0, y: player.spriteNode.size.height)
        let bombNode = SpriteBuilder<BombNode>()
            .setTexture(texture)
            .setPosition(position)
            .setZPosition(1)
            .setSizeByHeight(player.spriteNode.size.height/2.5)
            .setPhysicsBody(isDynamic: true, isTexured: true)
            .setPhysicsCategories(mask: PhysicsCategory.bomb, collision: [PhysicsCategory.monster, PhysicsCategory.obstacle], contact: [PhysicsCategory.monster, PhysicsCategory.obstacle])
            .build()
        return bombNode
    }
    
    static func createBullet(player: Player, direction: ShootDirection) -> BulletNode {
        let xScale: CGFloat = direction == .right ? 1 : -1
        let bulletNodeName = UIElementsNames.bulletNode.rawValue
        let texture = SKTexture(imageNamed: bulletNodeName)
        let x: CGFloat = direction == .left ? -player.spriteNode.size.width/1.5 : player.spriteNode.size.width/1.5
        let position: CGPoint = CGPoint(x: x, y: 0)
        let bulletNode = SpriteBuilder<BulletNode>()
            .setTexture(texture)
            .setPosition(position)
            .setSizeByHeight(player.spriteNode.size.height/5)
            .setPhysicsBody(isDynamic: true, isTexured: true)
            .setPhysicsCategories(mask: PhysicsCategory.playerProjectile, collision: [PhysicsCategory.monster, PhysicsCategory.obstacle], contact: [PhysicsCategory.monster, PhysicsCategory.obstacle])
            .build()
        bulletNode.zRotation += .pi / 2
        bulletNode.xScale = xScale
        return bulletNode
        
    }
}
