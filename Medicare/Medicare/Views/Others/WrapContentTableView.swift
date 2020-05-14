//
//  Int+Extension.swift
//  Medicare
//
//  Created by sanghv on 10/17/19.
//

import UIKit

final class WrapContentTableView: UITableView {

    override func reloadData() {
        super.reloadData()

        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()

        // return self.contentSize

        return CGSize(
            width: self.contentSize.width,
            height: self.contentSize.height / 1
        )
    }

    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
