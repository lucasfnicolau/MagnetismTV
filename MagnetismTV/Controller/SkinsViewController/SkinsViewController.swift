//
//  SkinsViewController.swift
//  MagnetismTV
//
//  Created by Lucas Fernandez Nicolau on 21/07/20.
//  Copyright © 2020 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class SkinsViewController: UIViewController {

    @IBOutlet weak var skinsCollectionView: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }


    private func setupCollectionView() {
        skinsCollectionView.delegate = self
        skinsCollectionView.dataSource = self
        skinsCollectionView.reloadData()
    }
}


extension SkinsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if SkinManager.shared.skins[indexPath.item].isAvailable {
            UserDefaults().set(indexPath.item, forKey: UDKey.currentSkinIndex)
            collectionView.reloadData()
        }
    }

}


extension SkinsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SkinManager.shared.skins.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.skinsCollectionViewCell, for: indexPath) as? SkinsCollectionViewCell {

            cell.setImages(skin: SkinManager.shared.skins[indexPath.item].image,
                           isAvailable: SkinManager.shared.skins[indexPath.item].isAvailable,
                           bg: backgroundImage(forItem: indexPath.item),
                           index: indexPath.item)
            return cell
        }

        return UICollectionViewCell()
    }


    private func backgroundImage(forItem item: Int) -> String {

        if item == 0 { return Image.topLeftClosed }
        if item == 1 { return Image.topMiddleClosed }
        if item == 2 { return Image.topRightClosed }

        if item == SkinManager.shared.skins.count - 3 { return Image.bottomLeftClosed }
        if item == SkinManager.shared.skins.count - 2 { return Image.bottomMiddleClosed }
        if item == SkinManager.shared.skins.count - 1 { return Image.bottomRightClosed }


        if (item + 2) % 3 == 0 { return Image.middle }
        if (item + 1) % 3 == 0 { return Image.right }
        if item % 3 == 0 { return Image.left }

        return ""
    }
}


extension SkinsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let aspectRatio: CGFloat = 1.4222
        let width: CGFloat = UIScreen.main.bounds.width / 3 - 90
        return CGSize(width: width,
                      height: width / aspectRatio)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

}
