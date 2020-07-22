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
    @IBAction func BackButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
