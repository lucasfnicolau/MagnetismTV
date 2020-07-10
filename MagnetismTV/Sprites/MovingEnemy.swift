//
//  MovingEnemy.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 08/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit

class MovingEnemy: SKSpriteNode, Movable, Enablable {

    enum Direction {
        case vertical
        case horizontal
    }

    static var bitmask: UInt32 = 0x0100

    var isEnabled: Bool = false
    private var nodeSpeed: CGFloat
    private var velocity = CGVector.zero
    private var direction: Direction


    init(withImage image: String? = nil,
         direction: Direction,
         nodeSpeed: CGFloat = 200,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        self.direction = direction
        self.nodeSpeed = nodeSpeed
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

        switch direction {
        case .horizontal:
            velocity.dx = nodeSpeed
        case .vertical:
            velocity.dy = nodeSpeed
        }

        physicsBody = SKPhysicsBody(rectangleOf: size.applying(CGAffineTransform(scaleX: 0.8, y: 0.8)))
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = MovingEnemy.bitmask
        physicsBody?.contactTestBitMask = Level.bitmask
        physicsBody?.collisionBitMask = Level.bitmask
    }


    func invert() {
        switch direction {
        case .horizontal:
            velocity.dx *= -1
        case .vertical:
            velocity.dy *= -1
        }
    }


    func move(basedOn dt: CGFloat) {
        guard isEnabled else { return }

        switch direction {
        case .horizontal:
            position.x += velocity.dx * dt
        case .vertical:
            position.y += velocity.dy * dt
        }
    }
}
