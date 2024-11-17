
import Foundation
import SpriteKit
import UIKit

class SpriteBuilder<NodeType: SKSpriteNode> {
    private var name: String?
    private var position: CGPoint?
    private var size: CGSize?
    private var texture: SKTexture?
    private var zPosition: CGFloat?
    
    func setName(_ name: String) -> SpriteBuilder {
        self.name = name
        return self
    }
    
    func setPosition(_ position: CGPoint) -> SpriteBuilder {
        self.position = position
        return self
    }
    
    func setSize(_ size: CGSize) -> SpriteBuilder {
        self.size = size
        return self
    }
    
    func setSizeByHeight(_ height: CGFloat) -> SpriteBuilder {
        guard let texture = texture else { return self }
        self.size = SizeProvider.getSizeByHeight(texture: texture, height: height)
        return self
    }
    
    func setSizeByWidth(_ width: CGFloat) -> SpriteBuilder {
        guard let texture = texture else { return self }
        self.size = SizeProvider.getSizeByWidth(texture: texture, width: width)
        return self
    }
    
    func setTexture(_ texture: SKTexture) -> SpriteBuilder {
        self.texture = texture
        return self
    }
    
    func setZPosition(_ zPosition: CGFloat) -> SpriteBuilder {
        self.zPosition = zPosition
        return self
    }
    
    func build() -> NodeType {
        var spriteNode: NodeType
        spriteNode = NodeType(texture: texture, size: size ?? .zero)
        spriteNode.position = position ?? .zero
        spriteNode.name = name
        spriteNode.zPosition = zPosition ?? 0
        return spriteNode
    }


}


import SpriteKit

class PhysicBodyBuilder {
    
    private var physicsBody: SKPhysicsBody?
    
    func withRectangle(size: CGSize) -> PhysicBodyBuilder {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        return self
    }
    
    func withTexture(_ texture: SKTexture, size: CGSize) -> PhysicBodyBuilder {
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        return self
    }
    
    func setIsDynamic(_ isDynamic: Bool) -> PhysicBodyBuilder {
        self.physicsBody?.isDynamic = isDynamic
        return self
    }
    
    func setMass(_ mass: CGFloat) -> PhysicBodyBuilder {
        self.physicsBody?.mass = mass
        return self
    }
    
    func setAffectedByGravity(_ affectedByGravity: Bool) -> PhysicBodyBuilder {
        self.physicsBody?.affectedByGravity = affectedByGravity
        return self
    }
    
    func setAllowsRotation(_ allowsRotation: Bool) -> PhysicBodyBuilder {
        self.physicsBody?.allowsRotation = allowsRotation
        return self
    }
    
    func setUsesPreciseCollisionDetection(_ usesPreciseCollisionDetection: Bool) -> PhysicBodyBuilder {
        self.physicsBody?.usesPreciseCollisionDetection = usesPreciseCollisionDetection
        return self
    }
    
    func setFriction(_ friction: CGFloat) -> PhysicBodyBuilder {
        self.physicsBody?.friction = friction
        return self
    }
    
    func setLinearDamping(_ linearDamping: CGFloat) -> PhysicBodyBuilder {
        self.physicsBody?.linearDamping = linearDamping
        return self
    }
    
    func setRestitution(_ restitution: CGFloat) -> PhysicBodyBuilder {
        self.physicsBody?.restitution = restitution
        return self
    }
    
    func setPhysicsCategories(mask: UInt32, collision: [UInt32], contact: [UInt32]) -> PhysicBodyBuilder {
        self.physicsBody?.categoryBitMask = mask
        self.physicsBody?.collisionBitMask = collision.reduce(0, |)
        self.physicsBody?.contactTestBitMask = contact.reduce(0, |)
        return self
    }
    
    
    
    func build() -> SKPhysicsBody? {
        return physicsBody
    }
}
