//
//  InfoView.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 20/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

@IBDesignable
class InfoView: UIView {

    private var label: UILabel?

    @IBInspectable var color: UIColor = #colorLiteral(red: 0.8, green: 0.6705882353, blue: 0.7764705882, alpha: 1) {
        didSet {
            setLayout()
        }
    }

    @IBInspectable var text: String = "" {
        didSet {
            label?.text = text
        }
    }

    @IBInspectable var fontSize: CGFloat = 50 {
        didSet {
            setLayout()
        }
    }


    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setLayout()
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }


    private func setLayout() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 5
        backgroundColor = #colorLiteral(red: 0.8, green: 0.6705882353, blue: 0.7764705882, alpha: 1)

        setLabel()
    }


    private func setLabel() {
        label = UILabel(frame: .zero)

        guard let label = label else { return }
        label.textAlignment = .center
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont(name: "FrenteH1-Regular",
                            size: fontSize)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
