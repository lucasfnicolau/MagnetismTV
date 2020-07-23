//
//  CustomButton.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 16/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }


    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setLayout()
    }


    private func setLayout() {
        backgroundColor = #colorLiteral(red: 0.862745098, green: 0.6352941176, blue: 0.3411764706, alpha: 1)
        titleLabel?.font = UIFont(name: "FrenteH1-Regular",
                                  size: titleLabel?.font.pointSize ?? 50)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        tintColor = .black
        adjustsImageWhenHighlighted = false
    }


    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select else { return }

        super.pressesBegan(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }


    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select else { return }

        super.pressesEnded(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })
    }


    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select else { return }

        super.pressesCancelled(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })
    }


    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard !presses.isEmpty && presses.first!.type == .select else { return }

        super.pressesChanged(presses, with: event)

        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })
    }


    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: UIView.inheritedAnimationDuration) {
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.7)
                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
            }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
                UIView.animate(withDuration: UIView.inheritedAnimationDuration * 2.0) {
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }, completion: nil)
        }
    }
}
