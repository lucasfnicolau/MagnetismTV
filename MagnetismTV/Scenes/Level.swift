//
//  Level0.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 07/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit

class Level: SKScene {

    private var lastUpdateTime: TimeInterval = 0
    private var player: Player
    private var movingEnemies = [Int: MovingEnemy]()
    private var enemiesNumber = 0
    private var mazeWalls: SKTileMapNode!
    static var bitmask: UInt32 = 0x0010


    required init?(coder aDecoder: NSCoder) {
        self.player = Player(withImage: "cowboy_head", andScale: 0.075)
        super.init(coder: aDecoder)
    }


    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.lastUpdateTime = 0

        guard let mazeWalls = childNode(withName: NodeName.mazeWalls)
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.mazeWalls = mazeWalls

        setupWallsCollision()
    }


    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
        addGestureRecognizers()
        calculateEnemiesNumber()
        createEnemies()
    }


    private func calculateEnemiesNumber() {
        enemiesNumber = children.reduce(Int.zero, { x, y in
            (y.name?.contains(NodeName.enemy) ?? false) ? x + 1 : x
        })
    }


    private func setupWallsCollision() {
        for column in 0 ..< mazeWalls.numberOfColumns {
            for row in 0 ..< mazeWalls.numberOfRows {
                guard let tileDefinition = mazeWalls.tileDefinition(atColumn: column,
                                                                    row: row) else { continue }

                let width = tileDefinition.size.width * mazeWalls.xScale
                let height = tileDefinition.size.height * mazeWalls.yScale

                let center = mazeWalls.centerOfTile(atColumn: column, row:
                    row).applying(CGAffineTransform(scaleX: mazeWalls.xScale, y: mazeWalls.yScale))

                let tileNode = SKNode()
                tileNode.position = center

                tileNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width,
                                                                         height: height))
                tileNode.physicsBody?.categoryBitMask = Level.bitmask
                tileNode.physicsBody?.restitution = 0
                tileNode.physicsBody?.isDynamic = false
                tileNode.physicsBody?.pinned = true
                tileNode.physicsBody?.allowsRotation = false

                self.addChild(tileNode)
            }
        }
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
        player.setVelocity(basedOn: swipe.direction)
    }


    private func createEnemies() {
        for index in 0 ..< enemiesNumber {
            var entryPoint: SKNode?
            let enemyH = self.childNode(withName: "\(NodeName.enemy)\(index)H")
            let enemyV = self.childNode(withName: "\(NodeName.enemy)\(index)V")
            var direction: MovingEnemy.Direction = .horizontal

            if enemyH != nil {
                entryPoint = enemyH
            } else if enemyV != nil {
                entryPoint = enemyV
                direction = .vertical
            }

            if entryPoint == nil { continue }

            let movingEnemy = MovingEnemy(withImage: "skull", direction: direction, andScale: 0.05)
            movingEnemy.position = entryPoint!.position
            addChild(movingEnemy)

            let key = movingEnemy.physicsBody?.hash ?? 0
            movingEnemies[key] = movingEnemy
        }
    }


    private func configure() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.restitution = 0

        guard let entryPoint = self.childNode(withName: NodeName.entryPoint) else {
            return
        }
        player.position = entryPoint.position
        addChild(player)
    }
    

    override func update(_ currentTime: TimeInterval) {
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        let dt: CGFloat = CGFloat(currentTime - self.lastUpdateTime)

        player.move(basedOn: dt)
        movingEnemies.values.forEach { $0.move(basedOn: dt) }

        self.lastUpdateTime = currentTime
    }
}

extension Level: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let keyA = contact.bodyA.hash
        let keyB = contact.bodyB.hash

        if movingEnemies[keyA] != nil { movingEnemies[keyA]?.invert() }
        else if movingEnemies[keyB] != nil { movingEnemies[keyB]?.invert() }
    }

}

