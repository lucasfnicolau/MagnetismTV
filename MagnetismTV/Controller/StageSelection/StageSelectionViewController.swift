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
    @IBOutlet weak var stagesCollectionView: UICollectionView!
    


    @IBAction func BackButtonTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stagesCollectionView.dataSource = self
        stagesCollectionView.delegate = self
    }
}

extension StageSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StageRowCell {
            cell.SelectionButton.isSelected = true
        }

        if let gameVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(identifier: Identifier.game) as? GameViewController {
            gameVC.start(sceneWithIndex: indexPath.item)
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StageRowCell {
            cell.SelectionButton.isSelected = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let nextIndexPath = context.nextFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: nextIndexPath) as? StageRowCell {
                cell.SelectionButton.isHighlighted = true
            }
        }
        if let previousIndexPath = context.previouslyFocusedIndexPath {
            if let cell = collectionView.cellForItem(at: previousIndexPath) as? StageRowCell {
                cell.SelectionButton.isHighlighted = false
            }
        }
    }
}

extension StageSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StageCell", for: indexPath)
        return cell
    }
}

extension StageSelectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width / 5) - 64
        return CGSize(width: width,
                      height: width)
    }


    private func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return centerItemsInCollectionView(cellWidth: Double((collectionView.frame.width / 5) - 64), numberOfItems: 5, spaceBetweenCell: 64, collectionView: collectionView)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

}
