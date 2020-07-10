//
//  TimerView.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 09/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class TimerView: UIView {

    private var timer: Timer?
    private var currentTime = 0
    private var timeLimit: Int
    private var colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)]
    private var size = CGSize(width: UIScreen.main.bounds.width - 60, height: 25)
    private let playerImageView: UIImageView
    private let tombstoneImageView: UIImageView


    init(timeLimit: Int) {
        self.playerImageView = UIImageView(image: UIImage(named: "cowboy_head"))
        self.tombstoneImageView = UIImageView(image: UIImage(named: "skull"))
        self.timeLimit = timeLimit
        super.init(frame: .zero)
        setBar()
        setImageViews()
        setTimer()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setBar() {
        frame = CGRect(x: 40, y: 20, width: size.width, height: size.height)
        backgroundColor = colors[0]
        layer.cornerRadius = frame.height / 4
    }


    private func setImageViews() {
        addSubview(playerImageView)
        addSubview(tombstoneImageView)

        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        tombstoneImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            playerImageView.widthAnchor.constraint(equalToConstant: 40),
            playerImageView.heightAnchor.constraint(equalToConstant: 40),
            playerImageView.leadingAnchor.constraint(equalTo: self.trailingAnchor),
            playerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            tombstoneImageView.widthAnchor.constraint(equalToConstant: 40),
            tombstoneImageView.heightAnchor.constraint(equalToConstant: 40),
            tombstoneImageView.trailingAnchor.constraint(equalTo: self.leadingAnchor),
            tombstoneImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }


    private func setTimer() {
        currentTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }


    @objc private func update() {
        currentTime += 1

        let colorIndex: Int
        if currentTime >= Int(0.75 * Double(timeLimit)) - 1 {
            colorIndex = 3
        } else if currentTime >= Int(0.5 * Double(timeLimit)) - 1 {
            colorIndex = 2
        } else if currentTime >= Int(0.25 * Double(timeLimit)) - 1 {
            colorIndex = 1
        } else {
            colorIndex = 0
        }

        UIView.animate(withDuration: 1) {
            self.backgroundColor = self.colors[colorIndex]
        }

        frame = CGRect(x: frame.minX,
                       y: frame.minY,
                       width: frame.width - size.width / CGFloat(timeLimit),
                       height: frame.height)
        layer.cornerRadius = min(frame.width, frame.height) / 4

        if currentTime >= timeLimit {
            subviews.forEach { $0.removeFromSuperview() }
            timer?.invalidate()
            NotificationCenter.default.post(name: NotificationName.timeIsUp, object: nil)
        }
    }


    func reset(withTimeLimit timeLimit: Int) {
        timer?.invalidate()
        self.timeLimit = timeLimit
        setBar()
        setTimer()
    }
}
