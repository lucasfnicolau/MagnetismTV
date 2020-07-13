//
//  InteractableDelegate.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 13/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

protocol InteractableDelegate: class {
    func itemHasBeenInteracted(_ item: Interactable)
}
