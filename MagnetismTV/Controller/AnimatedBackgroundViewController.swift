//
//  AnimatedBackgroundViewController.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 17/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class AnimatedBackgroundViewController: UIViewController {

    var animatedSnakeBackgroundView: AnimatedSnakeBackgroundView?


    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimatedBackground()
        view.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9098039216, blue: 0.937254902, alpha: 1)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatedSnakeBackgroundView?.play()
    }


    private func configureAnimatedBackground() {
        let snakeHead = UIImageView(image: #imageLiteral(resourceName: "Head"))
        snakeHead.transform = snakeHead.transform.rotated(by: 3 * .pi / 2)

        let snakeBody = UIImageView(image: #imageLiteral(resourceName: "Left Edge"))

        animatedSnakeBackgroundView = AnimatedSnakeBackgroundView(viewForHead: snakeHead,
                                                                  viewForBody: snakeBody)

        guard let animatedSnakeBackgroundView = animatedSnakeBackgroundView else { return }
        view.insertSubview(animatedSnakeBackgroundView, at: 0)

        NSLayoutConstraint.activate([
            animatedSnakeBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedSnakeBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedSnakeBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animatedSnakeBackgroundView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        animatedSnakeBackgroundView.isUserInteractionEnabled = false
    }
}
