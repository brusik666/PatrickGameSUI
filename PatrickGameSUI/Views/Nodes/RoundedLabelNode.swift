import SpriteKit

class RoundedLabelNode: SKLabelNode {
    private let backgroundNode: SKShapeNode
    
    init(text: String, fontColor: UIColor, fontSize: CGFloat) {
        backgroundNode = SKShapeNode()
        super.init()
        
        self.text = text
        self.isHidden = false
        self.fontSize = fontSize
        self.numberOfLines = 3
        //self.fontName = UIElementsNames.fontName.rawValue
        self.fontName = "Helvetica-Bold"
        //self.fontColor = UIColor.gameLabelsColor()
        self.fontColor = fontColor
        self.zPosition = ZPositions.cameraElements.rawValue
        
        backgroundNode.fillColor = .lightGray.withAlphaComponent(0.2)
        backgroundNode.lineWidth = 0
        backgroundNode.zPosition = self.zPosition - 1
        self.addChild(backgroundNode)
    }
    
    override var text: String? {
        didSet {
            super.text = text
            updateBackgroundSize()
        }
    }
    
    private func updateBackgroundSize() {
        let backgroundSize = CGSize(width: self.frame.width + 20, height: self.frame.height + 20)
        let backgroundPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: backgroundSize), cornerRadius: 10)
        backgroundNode.path = backgroundPath.cgPath
        backgroundNode.position = CGPoint(x: -self.frame.width / 2 - 10, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
