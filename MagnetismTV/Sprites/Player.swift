//
//  Player.swift
//  Magnetism
//
//  Created by Lucas Fernandez Nicolau on 06/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit

class Player: SKSpriteNode, Enablable {

    static let bitmask: UInt32 = 0x0001

    var isEnabled: Bool = false
    private var isMoving = false
    private var impulse: CGFloat = 2700.proportional(to: Level.scale)
    private var velocity = CGVector.zero


    init(withImage image: String? = nil,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: image!) : nil
        let size = (size == nil && texture != nil)
            ? texture!.size().applying(CGAffineTransform(scaleX: scale.proportional(to: Level.scale),
                                                         y: scale.proportional(to: Level.scale)))
            : CGSize(width: 50, height: 50)

        super.init(texture: texture, color: color, size: size)
        configure()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configure() {
        alpha = 0

        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2 * 0.9)
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = Player.bitmask
        physicsBody?.collisionBitMask = Level.bitmask | InteractableItem.bitmask
        physicsBody?.contactTestBitMask = MovingEnemy.bitmask | InteractableItem.bitmask
    }


    func setVelocity(basedOn direction: UISwipeGestureRecognizer.Direction) {
        guard isEnabled else { return }

        let action: SKAction

        switch direction {
        case .up:
            action = SKAction.applyImpulse(CGVector(dx: 0, dy: impulse), duration: 0.1)
        case .right:
            action = SKAction.applyImpulse(CGVector(dx: impulse, dy: 0), duration: 0.1)
        case .left:
            action = SKAction.applyImpulse(CGVector(dx: -impulse, dy: 0), duration: 0.1)
        case .down:
            action = SKAction.applyImpulse(CGVector(dx: 0, dy: -impulse), duration: 0.1)
        default:
            action = .init()
        }

        guard !isMoving else { return }
        isMoving = true
        run(action) {
            self.isMoving = false
        }
    }
}
