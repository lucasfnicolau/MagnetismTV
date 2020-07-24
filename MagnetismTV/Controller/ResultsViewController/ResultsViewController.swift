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


    override var preferredFocusedView: UIView? {
        return nextLevelButton
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupPortalAnimation()
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


    private func configure() {
        if score == -1 || level == -1 { return }

        let key = "\(UDKey.level)\(levelNumber(level))-\(UDKey.highscore)"

        var highscore = defaults.integer(forKey: key)
        if score > highscore {
            highscore = score
            defaults.set(score, forKey: key)
        }
        var allPoints = defaults.integer(forKey: UDKey.allPoints)
        allPoints += score
        defaults.set(allPoints, forKey: UDKey.allPoints)

        levelView.text = "LEVEL \(levelNumber(level))"
        scoreView.text = "SCORE: \(score)"
        highscoreView.text = "HIGHSCORE: \(highscore)"

        defaults.set(level, forKey: UDKey.currentLevel)
    }


    private func levelNumber(_ number: Int) -> String {
        if number >= 100 {
            return "\(number)"
        } else if number >= 10 {
            return "0\(number)"
        }
        return "00\(number)"
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
