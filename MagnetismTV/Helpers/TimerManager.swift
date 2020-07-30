//
//  TimerManager.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 21/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

class TimerManager {

    static func wait(_ seconds: TimeInterval, completion: @escaping () -> Void) {
        var pausedTime = 0
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { timer in
            if pausedTime == 1 {
                timer.invalidate()
                completion()
            }
            pausedTime += 1
        }.fire()
    }
    
}
