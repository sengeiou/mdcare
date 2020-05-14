//
//  TitleWithCheckmarkTableViewCell.swift
//  Medicare
//
//  Created by sanghv on 1/15/20.
//

import UIKit

final class TitleWithCheckmarkTableViewCell: TSBaseTableViewCell {

    fileprivate let titleLabel = UILabel()
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel
        ])

        return stackView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        accessoryType = selected ? .checkmark : .none
    }

    override func configView() {
        super.configView()

        accessoryType = .none
        selectionStyle = .none
        configStackView()
        configTitleLabel()
    }

    private func configStackView() {
        _ = stackView.then {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .center
            $0.distribution = .fill
        }

        contentView.addSubview(stackView)
        contentView.addConstraints(withFormat: "H:|-8-[v0]-8-|", views: stackView)
        contentView.addConstraints(withFormat: "V:|-4@750-[v0(>=36)]-4-|", views: stackView)
    }

    private func configTitleLabel() {
        _ = titleLabel.then {
            $0.font = .medium(size: 14.0)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
    }
}

extension TitleWithCheckmarkTableViewCell {

    override func configCellWithData(data: Any?) {
        guard let title = data as? String else {
            return
        }

        titleLabel.text = title
    }
}
