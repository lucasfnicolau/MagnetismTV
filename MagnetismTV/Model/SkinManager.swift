//
//  SkinManager.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 22/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

class SkinManager {

    private(set) var skins = [Skin]()

    static let shared = SkinManager()

    var currentSkin: Skin {
        let defaults = UserDefaults()
        let index = defaults.integer(forKey: UDKey.currentSkinIndex)
        return index < skins.count ? skins[index] : skins[0]
    }
    

    private init() {
        var pointsRequired = [
            0,
            1650,
            3500,
            7000,
            10000,
            15000
        ]

        while pointsRequired.count % 3 != 0 {
            pointsRequired.append(Int.max)
        }

        for (index, points) in pointsRequired.enumerated() {
            skins.append(Skin(image: "\(Sprite.birdie)\(index)",
                pointsRequired: points))
        }
    }
}
