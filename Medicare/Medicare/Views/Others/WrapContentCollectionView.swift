//
//  WrapContentCollectionView.swift
//  Medicare
//
//  Created by sanghv on 10/17/19.
//

import UIKit

class WrapContentCollectionView: UICollectionView {

    override func reloadData() {
        super.reloadData()

        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
