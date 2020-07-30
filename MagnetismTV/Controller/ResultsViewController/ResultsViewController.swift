//
//  ResultsViewController.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 20/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var levelView: InfoView!
    @IBOutlet weak var scoreView: InfoView!
    @IBOutlet weak var highscoreView: InfoView!
    @IBOutlet weak var portalImageView: UIImageView!
    @IBOutlet weak var nextLevelButton: CustomButton!

    var score: Int = -1
    var level: Int = -1
    var gameVC: GameViewController?
    private let defaults = UserDefaults()
    private let menuPressRecognizer = UITapGestureRecognizer()


    override var preferredFocusedView: UIView? {
        return nextLevelButton
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupPortalAnimation()
        setupMenuButtonBehavior()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }


    private func setupPortalAnimation() {
        var images = [UIImage]()
        for i in 0 ..< 5 {
            guard let image = UIImage(named: "\(Sprite.portal)\(i)-PNG") else {
                continue
            }
            images.append(image)
        }
        portalImageView.animationRepeatCount = 0
        portalImageView.animationDuration = 1
        portalImageView.animationImages = images
        portalImageView.startAnimating()
    }


    private func setupMenuButtonBehavior() {
        menuPressRecognizer.addTarget(self, action: #selector(menuButtonTouched))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
    }


    @objc private func menuButtonTouched() {}


    private func configure() {
        if score == -1 || level == -1 { return }

        let levelNumber = GameViewController.formattedLevelName(forIndex: level)

        let key = "\(UDKey.level)\(levelNumber)-\(UDKey.highscore)"

        var highscore = defaults.integer(forKey: key)
        if score > highscore {
            highscore = score
            defaults.set(score, forKey: key)
        }
        var allPoints = defaults.integer(forKey: UDKey.allPoints)
        allPoints += score
        defaults.set(allPoints, forKey: UDKey.allPoints)

        levelView.text = "LEVEL \(levelNumber)"
        scoreView.text = "SCORE: \(score)"
        highscoreView.text = "HIGHSCORE: \(highscore)"

        if level > defaults.integer(forKey: UDKey.currentLevel) {
            if GameViewController.doesSceneExists(atIndex: level + 1) {
                defaults.set(level + 1, forKey: UDKey.currentLevel)
            } else {
                defaults.set(level, forKey: UDKey.currentLevel)
            }
        }
    }


    @IBAction func homeButtonTouched(_ sender: CustomButton) {
        navigationController?.popToRootViewController(animated: true)
    }


    @IBAction func restartButtonTouched(_ sender: CustomButton) {
        navigationController?.popViewController(animated: true)
        gameVC?.start(sceneWithIndex: level)
    }


    @IBAction func nextLevelButtonTouched(_ sender: CustomButton) {
        navigationController?.popViewController(animated: true)
        gameVC?.start(sceneWithIndex: level + 1)
    }
}
