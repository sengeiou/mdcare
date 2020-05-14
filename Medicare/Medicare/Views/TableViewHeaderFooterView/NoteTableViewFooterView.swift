//
//  NoteTableViewFooterView.swift
//  Medicare
//
//  Created by sanghv on 1/1/20.
//

import UIKit

final class NoteTableViewFooterView: TSBaseTableViewHeaderFooterView {

    fileprivate var titleLabel: UILabel = UILabel()

    override func configView() {
        super.configView()

        configTitleLabel()
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.font = .regular(size: 11.0)
            $0.textColor = ColorName.c333333.color
            $0.numberOfLines = 0
        }

        contentView.addSubview(titleLabel)
        contentView.addConstraints(withFormat: "H:|-8-[v0]-8-|", views: titleLabel)
        contentView.addConstraints(withFormat: "V:|-[v0]-|", views: titleLabel)
    }
}

extension NoteTableViewFooterView {

    override func configHeaderWithData(data: Any?) {
        titleLabel.text = data as? String
    }
}
