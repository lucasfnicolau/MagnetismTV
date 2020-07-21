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


    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func continueButtonTouched(_ sender: CustomButton) {
        let gameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(identifier: Identifier.game)

        navigationController?.pushViewController(gameVC, animated: true)
    }


    @IBAction func selectLevelButtonTouched(_ sendeR: CustomButton) {

    }


    @IBAction func toggleMusicButtonTouched(_ sendeR: CustomButton) {

    }
}
