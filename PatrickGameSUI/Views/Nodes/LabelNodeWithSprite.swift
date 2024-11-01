
import Foundation
import SpriteKit

class SKLabelNodeWithSprite: SKNode {
    
    var labelNode: SKLabelNode
    var spriteNode: SKSpriteNode
    
    init(text: String, spriteImageName: String, spriteHeight: CGFloat) {
        labelNode = SKLabelNode(text: text)
        labelNode.fontSize = 50
        //labelNode.fontName = UIElementsNames.fontName.rawValue
        labelNode.fontColor = .white
        spriteNode = SKSpriteNode(imageNamed: spriteImageName)
        spriteNode.size.height = spriteHeight
        spriteNode.size.width = spriteHeight
        spriteNode.position.y += 15
        spriteNode.position.x += 10
        
        super.init()
        
        addChild(spriteNode)
        addChild(labelNode)
        //zPosition = ZPositions.cameraElements.rawValue
        labelNode.position.x = -spriteNode.size.width / 2 - labelNode.frame.size.width / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
