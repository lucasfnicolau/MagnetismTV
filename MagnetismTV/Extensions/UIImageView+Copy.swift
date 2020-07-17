//
//  UIImageView+Copy.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 17/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

extension UIImageView {
    open override func copy() -> Any {
        let copy = UIImageView(image: image)
        copy.transform = transform
        copy.frame = frame

        return copy
    }
}
