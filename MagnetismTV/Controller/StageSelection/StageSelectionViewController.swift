//
//  StageSelectionController.swift
//  MagnetismTV
//
//  Created by Rafael Galdino on 20/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import Foundation
import UIKit

class StageSelectionViewController: AnimatedBackgroundViewController {
    let model: StageSelectionModel = StageSelectionModel()
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!


    @IBAction func BackButtonTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func stageButtonTapped(_ button: CustomButton) {
        guard let gameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(identifier: Identifier.game) as? GameViewController else { return }

        gameVC.currentLevel = button.tag

        navigationController?.pushViewController(gameVC, animated: true)
    }
}
