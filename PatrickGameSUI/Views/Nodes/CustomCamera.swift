import SpriteKit

class CustomCamera: SKCameraNode {
    private var targetPosition: CGPoint?
    private var smoothingFactor: CGFloat = 0.1 // Controls the smoothness of the camera movement
    private var accelerationOffsetMultiplier: CGFloat = 1.65
    private var baseOffset: CGPoint = .zero
    private var isAccelerating: Bool = false

    /// Configures the camera with a base offset and a smoothing factor.
    /// - Parameters:
    ///   - baseOffset: The default offset for the camera relative to the player.
    ///   - smoothingFactor: A value between 0 and 1 for smoothness (closer to 1 is slower).
    func configure(baseOffset: CGPoint, smoothingFactor: CGFloat) {
        self.baseOffset = baseOffset
        self.smoothingFactor = smoothingFactor
    }

    /// Starts the acceleration effect, enabling smooth movement.
    func startAcceleration() {
        isAccelerating = true
    }

    /// Stops the acceleration effect, switching back to direct movement.
    func stopAcceleration() {
        isAccelerating = false
    }

    /// Updates the camera position based on the player's position.
    /// - Parameter playerPosition: The current position of the player.
    func updateCameraPosition(playerPosition: CGPoint) {
        // Calculate the offset target position
        let dynamicOffset = isAccelerating ? baseOffset * accelerationOffsetMultiplier : baseOffset
        targetPosition = CGPoint(
            x: playerPosition.x + dynamicOffset.x,
            y: playerPosition.y + dynamicOffset.y
        )

        guard let targetPosition = targetPosition else { return }

        if isAccelerating {
            // Smoothly interpolate the camera's position towards the target
            position.x += (targetPosition.x - position.x) * smoothingFactor
            position.y += (targetPosition.y - position.y) * smoothingFactor
        } else {
            // Directly follow the player's position with no smoothing
            position = targetPosition
        }
    }
}

extension CGPoint {
    static func *(point: CGPoint, multiplier: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * multiplier, y: point.y * multiplier)
    }
}


