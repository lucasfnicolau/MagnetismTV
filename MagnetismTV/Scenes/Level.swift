//
//  Level.swift
//  Magnetism
//
//  Created by Lucas Fernandez Nicolau on 06/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit

class Level: SKScene {

    private var player: Player


    override init(size: CGSize) {
        self.player = Player(withImage: "taco_lucas", andScale: 0.45)
        super.init(size: size)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
        addGestureRecognizers()
    }


    private func addGestureRecognizers() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(swipe:)))
        swipeUp.direction = .up

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(swipe:)))
        swipeRight.direction = .right

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(swipe:)))
        swipeLeft.direction = .left

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(swipe:)))
        swipeDown.direction = .down

        view?.addGestureRecognizer(swipeUp)
        view?.addGestureRecognizer(swipeRight)
        view?.addGestureRecognizer(swipeLeft)
        view?.addGestureRecognizer(swipeDown)
    }


    @objc private func didSwipe(swipe: UISwipeGestureRecognizer) {
        player.move(to: swipe.direction)
    }


    private func configure() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.restitution = 0

        player.position = CGPoint(x: 100, y: 100)
        addChild(player)
    }
}

extension Level: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {

    }
    
}
