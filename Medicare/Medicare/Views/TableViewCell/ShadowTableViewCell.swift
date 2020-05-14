//
//  ShadowTableViewCell.swift
//  Medicare
//
//  Created by Thuan on 3/6/20.
//

import Foundation

public enum CornerType {
    case none
    case top
    case bottom
    case all
}

class ShadowTableViewCell: TSBaseTableViewCell {

    public weak var tableview: UITableView?
    private var cornerType: CornerType = .none
    private var cornerPadding = CornerPadding(x: 5.0, y: 5.0)

    private func manuallyLayout() {
        switch cornerType {
        case .none:
            self.unroundAllCorners()
        case .top:
            self.roundTopCorners()
        case .bottom:
            self.roundBottomCorners()
        default:
            self.roundAllCorners()
        }
    }

    func setCornerType(_ type: CornerType,
                       cornerPadding: CornerPadding = CornerPadding(x: 5.0, y: 5.0),
                       in tableView: UITableView? = nil) {
        cornerType = type
        self.cornerPadding = cornerPadding

        if self.tableview == nil {
            self.tableview = tableView
        }
    }
}

extension ShadowTableViewCell {

    override func configView() {
        super.configView()

        selectionStyle = .none
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        manuallyLayout()
        if let tv = tableview, let index = indexPath {
            addShadowToCellInTableView(tv: tv,
                                       indexPath: index,
                                       cornerRadius: 10,
                                       padding: cornerPadding)
        }
    }
}
