//
//  AudioManager.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 14/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation
import AVKit

class AudioManager {

    static let shared = AudioManager()
    static var numberOfLoops = 0

    var audioPlayer: AVAudioPlayer?


    private init() {}


    func setAudio(named name: String, withExtension extensionType: String = "mp3") {
        if let url = Bundle.main.url(forResource: name, withExtension: extensionType) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = AudioManager.numberOfLoops
            } catch {
                print(error)
            }
        }
    }
}
