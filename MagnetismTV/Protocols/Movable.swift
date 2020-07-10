//
//  Movable.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 08/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol Movable {
    var isEnabled: Bool { get set }
    func move(basedOn dt: CGFloat)
}
