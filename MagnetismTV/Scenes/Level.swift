//
//  Level0.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 07/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit
import UIKit
import AVKit

class Level: SKScene {

    static var scale: CGFloat = 1
    private(set) static var bitmask: UInt32 = 0x0010

    private var lastUpdateTime: TimeInterval = 0
    private var player: Player!
    private var movingEnemies = [Int: MovingEnemy]()
    private var interactableItems = [Int: InteractableItem]()
    private var mazeWalls: SKTileMapNode!
    var viewController: GameViewController!


    override func sceneDidLoad() {
        super.sceneDidLoad()
        lastUpdateTime = 0

        guard let mazeWalls = childNode(withName: NodeName.mazeWalls)
            as? SKTileMapNode else {
                fatalError("Background node not loaded")
        }
        self.mazeWalls = mazeWalls

        Level.scale = min(mazeWalls.xScale, mazeWalls.yScale)

        self.player = Player(withImage: "\(Sprite.birdie)0", andScale: 0.7)

        setupWallsCollision()
    }


    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
        addGestureRecognizers()
        createInteractableItems()
        createEnemies()
        createPortal()
    }


    private func createPortal() {
        let portal = InteractableItem(withImage: Sprite.portal,
                                      interactableDelegate: viewController,
                                      spriteType: Sprite.portal,
                                      andScale: 0.28)
        guard let entryPoint = childNode(withName: Sprite.portal),
            let key = portal.physicsBody?.hash else { return }
        interactableItems[key] = portal
        addNode(portal, at: entryPoint.position)
    }


    private func createInteractableItems() {
        let itemsEntryPoints = children.filter { $0.name?.contains(NodeName.interactable) ?? false }

        for entryPoint in itemsEntryPoints {
            var interactableItem: InteractableItem?
            if entryPoint.name?.contains(NodeName.addTimeItem) ?? false {
                interactableItem = AddTimeItem(withImage:
                    "\(Sprite.addTimeItem)0",
                    interactableDelegate: viewController,
                    andScale: 1.5)
            }

            if interactableItem == nil { continue }

            addNode(interactableItem!, at: entryPoint.position)

            guard let key = interactableItem!.physicsBody?.hash else { return }
            interactableItems[key] = interactableItem
        }
    }


    private func setupWallsCollision() {
        for column in 0 ..< mazeWalls.numberOfColumns {
            for row in 0 ..< mazeWalls.numberOfRows {
                guard let tileDefinition = mazeWalls.tileDefinition(atColumn: column,
                                                                    row: row) else { continue }

                if tileDefinition.name?.contains("MazeBackground") ?? false { continue }

                let width = 128 * mazeWalls.xScale
                let height = 128 * mazeWalls.yScale

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
                tileNode.physicsBody?.usesPreciseCollisionDetection = true

                addChild(tileNode)
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
        let enemiesEntryPoints = children.filter { $0.name?.contains(NodeName.enemy) ?? false }

        for entryPoint in enemiesEntryPoints {

            let direction: MovingEnemy.Direction
            if entryPoint.name?.contains("H") ?? false {
                direction = .horizontal
            } else { // if entryPoint.name?.contains("V") ?? false {
                direction = .vertical
            }

            let movingEnemy = MovingEnemy(withImage: "\(Sprite.foxie)0", direction: direction, andScale: 0.65)
            addNode(movingEnemy, at: entryPoint.position)

            guard let key = movingEnemy.physicsBody?.hash else { return }
            movingEnemies[key] = movingEnemy
        }
    }


    private func configure() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = Level.bitmask

        guard let entryPoint = childNode(withName: NodeName.entryPoint) else {
            return
        }
        addNode(player, at: entryPoint.position)
    }
    

    override func update(_ currentTime: TimeInterval) {
        if (lastUpdateTime == 0) { lastUpdateTime = currentTime }
        let dt: CGFloat = CGFloat(currentTime - lastUpdateTime)

        movingEnemies.values.forEach { $0.move(basedOn: dt) }

        lastUpdateTime = currentTime
    }


    private func addNode(_ node: SKNode & Enablable, at position: CGPoint) {
        var node = node
        node.position = position
        addChild(node)

        node.run(SKAction.fadeIn(withDuration: 0.5)) {
            node.isEnabled = true
        }
    }


    func getScore() -> Int {
        guard let scoreNode = children.first(where: { $0.name?.contains("Score") ?? false }),
            let components = scoreNode.name?.components(separatedBy: "-"),
            components.count > 1 else {
            return 500
        }

        return Int(components[1]) ?? 500
    }


    func getTimeLimit() -> Int {
        guard let timeLimitNode = children.first(where: { $0.name?.contains("TimeLimit") ?? false }),
            let components = timeLimitNode.name?.components(separatedBy: "-"),
            components.count > 1 else {
                return 60
        }

        return Int(components[1]) ?? 60
    }
}

extension Level: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let keyA = contact.bodyA.hash
        let keyB = contact.bodyB.hash

        if player.physicsBody?.hash == keyA && movingEnemies[keyB] != nil
            || player.physicsBody?.hash == keyB && movingEnemies[keyA] != nil {
            NotificationCenter.default.post(name: NotificationName.playerKilled, object: nil)
        }

        if player.physicsBody?.hash == keyA && interactableItems[keyB] != nil
            || player.physicsBody?.hash == keyB && interactableItems[keyA] != nil {

            var collectableItem: InteractableItem?
            if interactableItems[keyA] != nil {
                collectableItem = interactableItems[keyA]
            } else if interactableItems[keyB] != nil {
                collectableItem = interactableItems[keyB]
            }

            guard let item = collectableItem else { return }
            item.delegate?.itemHasBeenInteracted(item)
            item.removeFromParent()
        }

        if movingEnemies[keyA] != nil { movingEnemies[keyA]?.invert() }
        else if movingEnemies[keyB] != nil { movingEnemies[keyB]?.invert() }
    }


    func pause() {
        movingEnemies.values.forEach { $0.isEnabled = false }
    }


    func resume() {
        var pausedTime = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if pausedTime == 1 {
                self.movingEnemies.values.forEach { $0.isEnabled = true }
                timer.invalidate()
            }
            pausedTime += 1
        }.fire()
    }
}
