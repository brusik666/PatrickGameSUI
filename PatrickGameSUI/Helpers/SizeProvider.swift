
import SpriteKit


struct SizeProvider {
    
    static func getSizeByHeight(texture: SKTexture, height: CGFloat) -> CGSize {
        let ratio = height/texture.size().height
        let size = CGSize(width: texture.size().width * ratio, height: height)
        
        return size
    }
    
    static func getSizeByWidth(texture: SKTexture, width: CGFloat) -> CGSize {
        let ratio = width/texture.size().width
        let size = CGSize(width: width, height: texture.size().height * ratio)
        return size
    }
    
    static func buttonHeight(sceneHeight: CGFloat) -> CGFloat {
        return sceneHeight * 0.09
    }

    
    static func coinHeight(sceneHeight: CGFloat) -> CGFloat {
        return sceneHeight * 0.1
    }
}

