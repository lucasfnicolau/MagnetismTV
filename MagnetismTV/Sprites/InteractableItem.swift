//
//  InteractableItem.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 13/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit

class InteractableItem: SKSpriteNode, Interactable, Enablable {

    var isEnabled: Bool = false
    weak var delegate: InteractableDelegate?
    var spriteType: String?

    static let bitmask: UInt32 = 0x1000


    init(withImage image: String? = nil,
         interactableDelegate: InteractableDelegate,
         spriteType: String? = nil,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: image!) : nil
        let size = (size == nil && texture != nil)
            ? texture!.size().applying(CGAffineTransform(scaleX: scale, y: scale))
            : CGSize(width: 50, height: 50)

        self.spriteType = spriteType
        self.delegate = interactableDelegate
        super.init(texture: texture, color: color, size: size)
        self.xScale = scale
        self.yScale = scale
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
        physicsBody?.categoryBitMask = InteractableItem.bitmask
        physicsBody?.collisionBitMask = Level.bitmask
    }

}
