//
//  CollectableDelegate.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 13/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

protocol CollectableDelegate: class {
    func itemHasBeenCollected(_ item: Collectable)
}
