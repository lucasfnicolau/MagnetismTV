//
//  AnimatedBackground.swift
//  MagnetismTV
//
//  Created by Rafael Galdino on 13/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation
import UIKit

enum SnakeDirection {
    case up
    case down
    case left
    case right
}

struct UISnakeTrajectory {
    var startPoint: CGPoint
    var endPoint: CGPoint
    var angle: CGFloat
}

class AnimatedSnakeBackgroundView: UIView {
    let length: Int
    let size: CGRect
    let speed: Double
    let screenSize = UIScreen.main.bounds
    let releaseInterval: TimeInterval
    private var timer: Timer?

    let snakeHead: UIView
    let snakeBody: UIView
    let snakeTail: UIView

    init(viewForHead snakeHead: UIView? = nil, viewForBody snakeBody: UIView, viewForTail snakeTail: UIView? = nil, snakeLength: Int = 10, snakeSize: Double = 128, snakeSpeed: Double = 8.0, releaseInterval: TimeInterval = 4.0) {
        if let head = snakeHead {
            self.snakeHead = head
        } else {
            self.snakeHead = snakeBody
        }
        if let tail = snakeTail {
            self.snakeTail = tail
        } else {
            self.snakeTail = snakeBody
        }
        self.snakeBody = snakeBody
        self.length = snakeLength
        self.size = CGRect(x: 0, y: 0, width: CGFloat(snakeSize), height: CGFloat(snakeSize))
        self.speed = snakeSpeed
        self.releaseInterval = releaseInterval
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.snakeHead.frame = self.size
        self.snakeBody.frame = self.size
        self.snakeTail.frame = self.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func play() {
        self.stop()
        timer = Timer.scheduledTimer(timeInterval: releaseInterval,
                                         target: self,
                                         selector: #selector(self.launchSnake),
                                         userInfo: nil,
                                         repeats: true)
        timer?.fire()
    }

    func stop() {
        timer?.invalidate()
        for view in subviews {
            view.removeFromSuperview()
        }
    }


    @objc func launchSnake() {
        var snakeImages: [UIImageView] = buildSnake()

        let randomX = screenSize.width * CGFloat.random(in: 0..<1)
        let startPoint =  CGPoint(x: randomX, y: 0 - snakeHead.frame.height/2)
        let endPoint = CGPoint(x: randomX, y: screenSize.height + (self.snakeHead.frame.height) * CGFloat(length))

        for index in 0...length {
            snakeImages[index].center = CGPoint(x: startPoint.x, y: startPoint.y - (CGFloat(index) * snakeBody.frame.height))
        }

        UIView.animate(withDuration: speed, delay: 0.0, options: .curveLinear, animations: {
            for index in (0..<self.length).reversed() {
                snakeImages[index].center = CGPoint(x: endPoint.x, y: endPoint.y - (CGFloat(index) * self.snakeBody.frame.height))
            }
        }) { (finished) in
            if finished {
                self.rotateSnake(snakeImages: &snakeImages)
                UIView.animate(withDuration: self.speed, delay: 0.0, animations: {
                    for index in 0..<self.length {
                        snakeImages[index].center = CGPoint(x: startPoint.x, y: startPoint.y - (CGFloat(index) * self.snakeBody.frame.height))
                    }
                }) { (_) in
                    for image in snakeImages {
                        image.removeFromSuperview()
                    }
                }
            }
        }
    }

    private func rotateSnake(snakeImages: inout [UIImageView]) {
        let partSwapAux = snakeImages[0].center

        for image in snakeImages {
            image.transform = image.transform.rotated(by: .pi)
        }

        snakeImages[0].center = snakeImages[length-1].center
        snakeImages[length-1].center = partSwapAux
        snakeImages.swapAt(0, self.length-1)
    }

    private func buildSnake() -> [UIImageView] {
        var snakeImages: [UIImageView] = []

        if let headPart = snakeHead.copy() as? UIImageView {
            snakeImages.append(headPart)
            addSubview(headPart)
        }
        for _ in 1..<length {
            if let bodyPart = snakeBody.copy() as? UIImageView {
                snakeImages.append(bodyPart)
                self.addSubview(bodyPart)
            }
        }
        if let tailPart = snakeTail.copy() as? UIImageView {
            snakeImages.append(tailPart)
            addSubview(tailPart)
        }
        return snakeImages
    }
}
