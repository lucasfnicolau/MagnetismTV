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

    enum VDirection: String {
        case top = "T"
        case bottom = "B"
    }

    enum HDirection: String {
        case left = "L"
        case right = "R"
    }

    static let bitmask: UInt32 = 0x0001

    var isEnabled: Bool = false
    private var isMoving = false
    private var impulse: CGFloat = 2700.proportional(to: Level.scale)
    private var velocity = CGVector.zero
    private var vDirection: VDirection = .bottom
    private var hDirection: HDirection = .right


    init(withImage image: String? = nil,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: "\(image!)-BR") : nil
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

        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
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

        setNewDirection(basedOn: direction)

        let moveAction: SKAction
        let changeTextureAction: SKAction
        let image = "\(SkinManager.shared.currentSkin.image)-\(vDirection.rawValue)\(hDirection.rawValue)"

        switch direction {
        case .up:
            moveAction = SKAction.applyImpulse(CGVector(dx: 0, dy: impulse), duration: 0.1)
            changeTextureAction = SKAction.setTexture(SKTexture(imageNamed: image))
        case .right:
            moveAction = SKAction.applyImpulse(CGVector(dx: impulse, dy: 0), duration: 0.1)
            changeTextureAction = SKAction.setTexture(SKTexture(imageNamed: image))
        case .left:
            moveAction = SKAction.applyImpulse(CGVector(dx: -impulse, dy: 0), duration: 0.1)
            changeTextureAction = SKAction.setTexture(SKTexture(imageNamed: image))
        case .down:
            moveAction = SKAction.applyImpulse(CGVector(dx: 0, dy: -impulse), duration: 0.1)
            changeTextureAction = SKAction.setTexture(SKTexture(imageNamed: image))
        default:
            return
        }

        guard !isMoving else { return }

        isMoving = true
        run(changeTextureAction)
        run(moveAction) {
            self.isMoving = false
        }
    }


    private func setNewDirection(basedOn gestureDirection: UISwipeGestureRecognizer.Direction) {
        switch gestureDirection {
        case .up:
            vDirection = .top
        case .right:
            hDirection = .right
        case .left:
            hDirection = .left
        case .down:
            vDirection = .bottom
        default:
            return
        }
    }
}
