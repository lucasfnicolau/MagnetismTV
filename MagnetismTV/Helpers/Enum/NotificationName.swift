//
//  NotificationName.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 09/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation

enum NotificationName {
    static let timeIsUp = NSNotification.Name("timeIsUp")
    static let playerKilled = NSNotification.Name("playerKilled")
    static let didEnterBackground = NSNotification.Name("didEnterBackground")
    static let didEnterForeground = NSNotification.Name("didEnterForeground")
    static let onPortalReached = NSNotification.Name("onPortalReached")
}
