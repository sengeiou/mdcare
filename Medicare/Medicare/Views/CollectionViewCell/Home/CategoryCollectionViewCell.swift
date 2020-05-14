//
//  CategoryCollectionViewCell.swift
//  Medicare
//
//  Created by Thuan on 4/1/20.
//

import UIKit

final class CategoryCollectionViewCell: TSBaseCollectionViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var lbCategory: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension CategoryCollectionViewCell {

    override func configView() {
        super.configView()

        configLabel()
    }

    fileprivate func configLabel() {
        _ = lbCategory.then {
            $0.font = .regular(size: 12)
            $0.textColor = ColorName.c333333.color
        }
    }
}
