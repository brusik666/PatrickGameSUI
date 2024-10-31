
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


class PhysicBodyBuilder {
    
    private var physicsBody: SKPhysicsBody?
    
    
    func configurePhysicsBody(isDynamic: Bool, mass: CGFloat = 10.0, affectedByGravity: Bool = false, isTextured: Bool, hasPresizeCollision: Bool = false, spriteNode: SKSpriteNode, allowsRotation: Bool = false) -> PhysicBodyBuilder {
        
        guard let textur = spriteNode.texture else { return self }
        let size = spriteNode.size
        if isTextured {
            self.physicsBody = SKPhysicsBody(texture: textur, size: size)
        } else {
            self.physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        self.physicsBody?.mass = mass
        self.physicsBody?.usesPreciseCollisionDetection = hasPresizeCollision
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.affectedByGravity = affectedByGravity
        return self
    }
    
    func setPhysicsCategories(mask: UInt32, collision: [UInt32], contact: [UInt32]) -> PhysicBodyBuilder {
        self.physicsBody?.categoryBitMask = mask
        if !collision.isEmpty {
            self.physicsBody?.collisionBitMask = collision.reduce(0, |)
        }
        
        if !contact.isEmpty {
            self.physicsBody?.contactTestBitMask = contact.reduce(0, |)
        }
        return self
    }
    
    func build() -> SKPhysicsBody? {
        return physicsBody
    }
}
