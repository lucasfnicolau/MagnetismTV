//
//  Player.swift
//  Magnetism
//
//  Created by Lucas Fernandez Nicolau on 06/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit

class Player: SKSpriteNode {

    static var mask: UInt32 = 0x0001
    

    private var impulse: CGFloat = 4000
    private var isMoving = false


    init(withImage image: String? = nil,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: image!) : nil
        let size = (size == nil && texture != nil) ? texture!.size() : CGSize(width: 50, height: 50)
        super.init(texture: texture, color: color, size: size)
        xScale = scale
        yScale = scale
        configure()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configure() {
        if let texture = texture {
            physicsBody = SKPhysicsBody(texture: texture, size: size)
        } else {
            physicsBody = SKPhysicsBody(rectangleOf: size)
        }
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = Player.mask
    }


    func move(to direction: UISwipeGestureRecognizer.Direction) {
        let action: SKAction

        switch direction {
        case .up:
            action = SKAction.applyImpulse(CGVector(dx: 0, dy: impulse), duration: 0.02)
        case .right:
            action = SKAction.applyImpulse(CGVector(dx: impulse, dy: 0), duration: 0.02)
        case .left:
            action = SKAction.applyImpulse(CGVector(dx: -impulse, dy: 0), duration: 0.02)
        case .down:
            action = SKAction.applyImpulse(CGVector(dx: 0, dy: -impulse), duration: 0.02)
        default:
            action = SKAction.init()
        }

        guard !isMoving else { return }

        isMoving = true
        self.run(action) { self.isMoving = false }
    }
}
