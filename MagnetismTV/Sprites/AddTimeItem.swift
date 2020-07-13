//
//  AddTimeItem.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 11/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import SpriteKit

class AddTimeItem: InteractableItem {

    let extraTime: Int


    init(withImage image: String? = nil,
         interactableDelegate: InteractableDelegate,
         extraTime: Int = 5,
         color: UIColor = .clear,
         size: CGSize? = nil,
         andScale scale: CGFloat = 1) {

        let texture = image != nil ? SKTexture(imageNamed: image!) : nil
        let size = (size == nil && texture != nil)
            ? texture!.size().applying(CGAffineTransform(scaleX: scale, y: scale))
            : CGSize(width: 50, height: 50)

        self.extraTime = extraTime
        super.init(withImage: image, interactableDelegate: interactableDelegate, color: color, size: size, andScale: scale)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
