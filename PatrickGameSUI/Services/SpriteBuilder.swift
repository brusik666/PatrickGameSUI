
import Foundation
import SpriteKit
import UIKit

class SpriteBuilder<NodeType: SKSpriteNode> {
    var name: String?
    var position: CGPoint?
    var size: CGSize?
    var texture: SKTexture?
    var physicsBody: SKPhysicsBody?
    var zPosition: CGFloat?
    
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
    
    func setPhysicsBody(isDynamic: Bool, mass: CGFloat = 10.0, affectedByGravity: Bool = false, isTexured: Bool, hasPresizeCollision: Bool = false) -> SpriteBuilder {
        guard let textur = texture,
              let size = size else { return self }
        if isTexured {
            self.physicsBody = SKPhysicsBody(texture: textur, size: size)
        } else {
            self.physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        self.physicsBody?.mass = mass
        self.physicsBody?.usesPreciseCollisionDetection = hasPresizeCollision
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.affectedByGravity = affectedByGravity
        return self
    }
    
    func setCirclePhysicBody(isDynamic: Bool, mass: CGFloat = 10.0, affectedByGravity: Bool = false) -> SpriteBuilder {
        guard let size = size else { return self}
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.height/2.2)
        self.physicsBody?.mass = mass
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.affectedByGravity = affectedByGravity
        return self
    }
    
    func setRoundedRectPhysicBody(isDynamic: Bool, mass: CGFloat = 10.0, affectedByGravity: Bool = false) -> SpriteBuilder {
        guard let size = size else { return self}
        let cornerRadius: CGFloat = 10
        let roundedRectPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: -size.width/2, y: 0), size: CGSize(width: size.width, height: size.height/2.5)), cornerRadius: cornerRadius)
        self.physicsBody = SKPhysicsBody(polygonFrom: roundedRectPath.cgPath)
        self.physicsBody?.mass = mass
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.isDynamic = isDynamic
        self.physicsBody?.affectedByGravity = affectedByGravity
        return self
    }
    
    func setPhysicsCategories(mask: UInt32, collision: [UInt32], contact: [UInt32]) -> SpriteBuilder {
        self.physicsBody?.categoryBitMask = mask
        if !collision.isEmpty {
            self.physicsBody?.collisionBitMask = collision.reduce(0, |)
        }
        
        if !contact.isEmpty {
            self.physicsBody?.contactTestBitMask = contact.reduce(0, |)
        }
        return self
    }
    
    func setZPosition(_ zPosition: CGFloat) -> SpriteBuilder {
        self.zPosition = zPosition
        return self
    }
    
    func isUpdatable() {
        
    }

    
    func build() -> NodeType {
        var spriteNode: NodeType
        spriteNode = NodeType(texture: texture, size: size ?? .zero)
        spriteNode.position = position ?? .zero
        spriteNode.physicsBody = physicsBody
        spriteNode.name = name
        spriteNode.zPosition = zPosition ?? 0
        return spriteNode
    }


}

