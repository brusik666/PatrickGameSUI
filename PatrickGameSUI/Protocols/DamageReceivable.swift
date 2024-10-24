import SpriteKit

protocol DamageReceivable: AnyObject {
    var hp: CGFloat { get set }
    var maxHP: CGFloat { get set }
    var spriteNode: SKSpriteNode { get set }
    var maxHPBar: SKSpriteNode { get set }
    var currentHPBar: SKSpriteNode { get set }
    var isInContactWithGun: Bool { get set }
    func takeDamage(amount: CGFloat)
}


extension DamageReceivable {

    func takeDamage(amount: CGFloat) {
        guard !isInContactWithGun else { return }
        isInContactWithGun = true
        if hp >= amount {
            hp -= amount
            //spriteNode.blinkAnimation()
            updateHPBars()
            spriteNode.run(.sequence([.wait(forDuration: 0.5), .run { [weak self] in
                self?.isInContactWithGun = false
            }]))
        } else {
            hp = 0
            updateHPBars()
        }
    }

    private func updateHPBars() {
        let percentage = hp / maxHP
        let newWidth = maxHPBar.size.width * percentage
        currentHPBar.size.width = newWidth
    }
}

