//
//  SkinsCollectionViewCell.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 21/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class SkinsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var skinImageView: UIImageView!
    @IBOutlet weak var pointsRequiredInfoView: InfoView!

    private let defaults = UserDefaults()
    private var isAvailable = true
    private var isAnimating = false


    override func awakeFromNib() {
        super.awakeFromNib()
    }


    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select && isAvailable else { return }

        super.pressesBegan(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.skinImageView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        })
    }


    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select && isAvailable else { return }

        super.pressesEnded(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.skinImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }


    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select && isAvailable else { return }

        super.pressesCancelled(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.skinImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }


    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select && isAvailable else { return }

        super.pressesChanged(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.skinImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }


    func setImages(skin: Skin, bg backgroundImageName: String, index: Int) {
        backgroundImageView.image = UIImage(named: backgroundImageName)

        guard let skinImage = UIImage(named: skin.image) else {
            skinImageView.image = nil
            isUserInteractionEnabled = false
            return
        }

        self.isAvailable = skin.isAvailable
        skinImageView.image = skin.isAvailable ? skinImage : UIImage(named: Image.birdieNotAvailable)
        skinImageView.alpha = defaults.integer(forKey: UDKey.currentSkinIndex) == index ? 1.0 : 0.5

        pointsRequiredInfoView.isHidden = isAvailable
        pointsRequiredInfoView.text = "\(skin.pointsRequired)"
    }


    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: UIView.inheritedAnimationDuration) {
                    self.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 0.6)
                    if self.isAvailable {
                        self.skinImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    }
                }
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: UIView.inheritedAnimationDuration * 2.0) {
                    self.backgroundColor = .clear
                    self.skinImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }, completion: nil)
        }
    }
}
