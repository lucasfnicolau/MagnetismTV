//
//  GameViewController.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 06/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var timerView: TimerView!
    private var currentLevel = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        addObservers()
        start(sceneWithIndex: currentLevel)
    }


    private func start(sceneWithIndex index: Int) {
        let name: String
        if index >= 100 {
            name = "Level\(index)"
        } else if index >= 10 {
            name = "Level0\(index)"
        } else {
            name = "Level00\(index)"
        }

        let scene = createScene(named: name)
        setupView(for: scene)
    }


    private func createScene(named name: String) -> SKScene {

        guard let levelScene = SKScene(fileNamed: name) else {
            print("Error creating .sks scene")
            return SKScene()
        }
        levelScene.scaleMode = .aspectFill
        return levelScene
    }


    private func setupView(for levelScene: SKScene) {
        view.subviews.forEach { $0.removeFromSuperview() }

        if let view = self.view as? SKView {
            timerView = TimerView(timeLimit: 60)
            view.addSubview(timerView)

            view.presentScene(levelScene)
            view.ignoresSiblingOrder = true

            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            #endif
        }
    }


    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: NotificationName.timeIsUp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: NotificationName.playerKilled, object: nil)
    }


    @objc private func notificationReceived(_ notif: Notification) {
        switch notif.name {
        case NotificationName.timeIsUp,
             NotificationName.playerKilled:
            start(sceneWithIndex: currentLevel)
        default:
            return
        }
    }
}
