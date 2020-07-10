//
//  Player.swift
//  Magnetism
//
//  Created by Lucas Fernandez Nicolau on 06/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit

class Player: SKSpriteNode, Movable {

    static var bitmask: UInt32 = 0x0001

    var isEnabled: Bool = false
    private var nodeSpeed: CGFloat = 4100
    private var velocity = CGVector.zero


    init(withImage image: String? = nil,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: image!) : nil
        let size = (size == nil && texture != nil)
            ? texture!.size().applying(CGAffineTransform(scaleX: scale, y: scale))
            : CGSize(width: 50, height: 50)

        super.init(texture: texture, color: color, size: size)
        configure()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configure() {
        alpha = 0
        nodeSpeed = 4100 // ≤ 4100 to prevent ignore collisions

        physicsBody = SKPhysicsBody(rectangleOf: size.applying(CGAffineTransform(scaleX: 0.8, y: 0.8)))
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = Player.bitmask
        physicsBody?.collisionBitMask = Level.bitmask
        physicsBody?.contactTestBitMask = MovingEnemy.bitmask
    }


    func setVelocity(basedOn direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .up:
            velocity = CGVector(dx: 0, dy: nodeSpeed)
        case .right:
            velocity = CGVector(dx: nodeSpeed, dy: 0)
        case .left:
            velocity = CGVector(dx: -nodeSpeed, dy: 0)
        case .down:
            velocity = CGVector(dx: 0, dy: -nodeSpeed)
        default:
            velocity = .zero
        }
    }


    func move(basedOn dt: CGFloat) {
        guard isEnabled else { return }
        position.x += velocity.dx * dt
        position.y += velocity.dy * dt
    }
}
