//
//  Skin.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 22/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

struct Skin {
    let image: String
    let pointsRequired: Int
    var isAvailable: Bool {
        return UserDefaults().integer(forKey: UDKey.allPoints) >= pointsRequired
    }

    init(image: String, pointsRequired: Int) {
        self.image = image
        self.pointsRequired = pointsRequired
    }
}
