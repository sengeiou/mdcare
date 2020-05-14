//
//  InputOnlyTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 3/5/20.
//

import UIKit

final class InputOnlyTableViewCell: RequiredValueTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func configView() {
        super.configView()

        configTextFields()
    }

    private func configTextFields() {
        let textFields: [UITextField] = [
            leftTextField
        ]

        textFields.forEach {
            $0.textColor = ColorName.c333333.color
            $0.font = .regular(size: 16.0)
        }
    }
}

extension InputOnlyTableViewCell {

}
