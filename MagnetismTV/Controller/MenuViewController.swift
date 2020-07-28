//
//  MenuViewController.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 16/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class MenuViewController: AnimatedBackgroundViewController {

    @IBOutlet weak var musicControlButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var selectLevelButton: UIButton!

    let defaults = UserDefaults()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupMusic()
    }


    private func setupMusic() {
        AudioManager.shared.setAudio(named: Sound.gameTheme)

        let musicDisabled = defaults.bool(forKey: UDKey.musicDisabled)
        if !musicDisabled {
            AudioManager.shared.audioPlayer?.play()
        } else {
            musicControlButton.setImage(UIImage(named: Image.noMusic), for: .normal)
        }
    }


    @IBAction func continueButtonTouched(_ sender: CustomButton) {
        guard let gameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(identifier: Identifier.game) as? GameViewController else { return }

        gameVC.currentLevel = 0// defaults.integer(forKey: UDKey.currentLevel)

        navigationController?.pushViewController(gameVC, animated: true)
    }


    @IBAction func selectLevelButtonTouched(_ sender: CustomButton) {

    }


    @IBAction func selectSkinButtonTouched(_ sender: CustomButton) {
        let selectSkinVC = UIStoryboard(name: Storyboard.skins, bundle: nil).instantiateViewController(identifier: Identifier.skins)

        navigationController?.pushViewController(selectSkinVC, animated: true)
    }


    @IBAction func toggleMusicButtonTouched(_ sender: CustomButton) {
        let musicDisabled = !defaults.bool(forKey: UDKey.musicDisabled)
        defaults.set(musicDisabled, forKey: UDKey.musicDisabled)

        let image: UIImage?
        if musicDisabled {
            AudioManager.shared.audioPlayer?.stop()
            image = UIImage(named: Image.noMusic)
        } else {
            AudioManager.shared.audioPlayer?.play()
            image = UIImage(named: Image.music)
        }

        musicControlButton.setImage(image, for: .normal)
    }
}
