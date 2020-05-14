//
//  UITableViewCell+Extension.swift
//  Medicare
//
//  Created by Thuan on 3/5/20.
//

import Foundation

public struct CornerPadding {
    let x: CGFloat
    let y: CGFloat
}

extension UITableViewCell {

    func addShadowToCellInTableView(tv: UITableView,
                                    indexPath: IndexPath,
                                    cornerRadius: CGFloat,
                                    padding: CornerPadding = CornerPadding(x: 5.0, y: 5.0)) {
        let isFirstRow = (indexPath.row == 0)
        let isLastRow = (indexPath.row == tv.numberOfRows(inSection: indexPath.section) - 1)

        backgroundColor = UIColor.clear

        var unRound = true
        var frame: CGRect = CGRect(x: padding.x,
                                   y: -cornerRadius,
                                   width: bounds.size.width - 2*padding.x,
                                   height: bounds.size.height + 2*cornerRadius)
        if isFirstRow && isLastRow {
            frame = CGRect(x: padding.x,
                           y: padding.y,
                           width: bounds.size.width - 2*padding.x,
                           height: bounds.size.height - 2*padding.y)
            unRound = false
        } else if isFirstRow {
            frame = CGRect(x: padding.x,
                           y: padding.y,
                           width: bounds.size.width - 2*padding.x,
                           height: bounds.size.height + cornerRadius)
            unRound = false
        } else if isLastRow {
            frame = CGRect(x: padding.x,
                           y: -(cornerRadius + padding.y),
                           width: bounds.size.width - 2*padding.x,
                           height: bounds.size.height + cornerRadius)
            unRound = false
        }

        let bgView = UIView(frame: frame)
        bgView.backgroundColor = UIColor.white
        bgView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        bgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bgView.layer.shadowOpacity = 1.0
        bgView.layer.shadowRadius = 7.0
        bgView.layer.cornerRadius = (unRound) ? 0 : cornerRadius

        backgroundView = bgView
    }
}
