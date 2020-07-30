//
//  StageSelectionController.swift
//  MagnetismTV
//
//  Created by Rafael Galdino on 20/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation
import UIKit

class StageSelectionViewController: UIViewController {

    let model: StageSelectionModel = StageSelectionModel()

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet var levelButtons: [CustomButton]!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvailableLevels()
    }


    private func setupAvailableLevels() {
        let currentLevel = UserDefaults().integer(forKey: UDKey.currentLevel)
        levelButtons.forEach {
            if $0.tag > currentLevel {
                $0.disable()
            }
        }
    }


    @IBAction func BackButtonTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }


    @IBAction func stageButtonTapped(_ button: CustomButton) {
        guard let gameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(identifier: Identifier.game) as? GameViewController else { return }

        guard button.canBeTouched else { return }

        gameVC.currentLevel = button.tag

        navigationController?.pushViewController(gameVC, animated: true)
    }
}
