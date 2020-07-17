//
//  CGFloat+Proportional.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 14/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

fileprivate let originalMapScale: CGFloat = 0.7

extension CGFloat {
    func proportional(to value: CGFloat) -> CGFloat {
        return self * value / originalMapScale
    }
}
