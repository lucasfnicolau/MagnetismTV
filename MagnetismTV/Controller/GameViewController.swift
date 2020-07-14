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

    private var timerScoreView: TimerScoreView!
    private var currentLevel = 0
    private var currentScene: Level?
    private var levelsTimeLimits = [60, 60]
    private var levelsMaxScores = [500, 500]

    private(set) static var isPaused = false


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

        self.currentScene = createScene(named: name)
        guard let currentScene = currentScene else { return }
        setupView(for: currentScene)
    }


    private func createScene(named name: String) -> Level? {
        guard let scene = SKScene(fileNamed: name) else {
            print("Error creating .sks scene")
            return nil
        }
        scene.scaleMode = .aspectFill

        if let levelScene = scene as? Level {
            return levelScene
        }
        return nil
    }


    private func setupView(for levelScene: SKScene) {
        view.subviews.forEach { $0.removeFromSuperview() }

        if let view = self.view as? SKView {
            timerScoreView = TimerScoreView(timeLimit: levelsTimeLimits[currentLevel],
                                            maxScore: levelsMaxScores[currentLevel])
            view.addSubview(timerScoreView)

            if let scene = levelScene as? Level {
                scene.viewController = self
            }

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
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: NotificationName.didEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(_:)), name: NotificationName.didEnterForeground, object: nil)
    }


    @objc private func notificationReceived(_ notif: Notification) {
        switch notif.name {
        case NotificationName.timeIsUp,
             NotificationName.playerKilled:
            start(sceneWithIndex: currentLevel)
        case NotificationName.didEnterBackground:
            pause()
        case NotificationName.didEnterForeground:
            resume()
        default:
            return
        }
    }


    @objc func pause() {
        GameViewController.isPaused = true
        timerScoreView.pause()
        currentScene?.pause()
    }
    

    @objc func resume() {
        GameViewController.isPaused = false
        timerScoreView.resume()
        currentScene?.resume()
    }
}

extension GameViewController: InteractableDelegate {

    func itemHasBeenInteracted(_ item: Interactable) {
        if let addTimeItem = item as? AddTimeItem {
            timerScoreView.addTime(addTimeItem.extraTime)
        } else if item.spriteType == Sprite.portal {
            print(timerScoreView.score)
            if currentLevel + 1 < levelsMaxScores.count { currentLevel += 1 }
            start(sceneWithIndex: currentLevel)
        }
    }
}
