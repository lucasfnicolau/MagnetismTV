//
//  Double+CGFloatProportional.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 14/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

fileprivate let originalMapScale: CGFloat = 0.7

extension Double {
    func proportional(to value: CGFloat) -> CGFloat {
        return CGFloat(self) * value / originalMapScale
    }


    func proportional(to value: Double) -> Double {
        return self * value / Double(originalMapScale)
    }
}
