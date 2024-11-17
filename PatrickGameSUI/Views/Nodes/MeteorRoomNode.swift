import Foundation
import SpriteKit

class MeteorRoomNode: SKNode {
    private let leftSensor: SKSpriteNode
    private let rightSensor: SKSpriteNode
    private let bottomSensor: SKSpriteNode
    private let offSet: CGFloat = 150
    
    init(sceneSize: CGSize) {
        let sensorWidth: CGFloat = 1
        let verticalSensorSize = CGSize(width: sensorWidth, height: sceneSize.height + offSet)
        let horizontalSensorSize = CGSize(width: sceneSize.width + offSet, height: sensorWidth)
        self.leftSensor = MeteorRoomNode.createSensor(size: verticalSensorSize)
        self.rightSensor = MeteorRoomNode.createSensor(size: verticalSensorSize)
        self.bottomSensor = MeteorRoomNode.createSensor(size: horizontalSensorSize)
        super.init()
        
        positionSensors(sceneSize: sceneSize)
        
        // Add sensors to the MeteorRoomNode
        addChild(leftSensor)
        addChild(rightSensor)
        addChild(bottomSensor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func positionSensors(sceneSize: CGSize) {
        bottomSensor.position = CGPoint(x: 0, y: -sceneSize.height / 2 - offSet / 2)
        leftSensor.position = CGPoint(x: -sceneSize.width / 2 - offSet / 2, y: 0)
        rightSensor.position = CGPoint(x: sceneSize.width / 2 + offSet / 2, y: 0)
    }
    
    private static func createSensor(size: CGSize) -> SKSpriteNode {
        let sensor = SKSpriteNode()
        sensor.size = size
        sensor.texture = SKTexture(imageNamed: ImageName.Buttons.dailyBonusButton.rawValue)
        sensor.physicsBody = PhysicBodyBuilder()
            .withRectangle(size: size)
            .setIsDynamic(false)
            .setAffectedByGravity(false)
            .setPhysicsCategories(mask: PhysicsCategory.meteorSensor, collision: [], contact: [PhysicsCategory.meteor])
            .build()
        return sensor
    }
}
