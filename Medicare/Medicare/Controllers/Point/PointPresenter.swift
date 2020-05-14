//
//  PointPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol PointViewDelegate: class {
    func didLoadPointHistory()
}

final class PointPresenter {

    fileprivate let gateway = PointGateway()
    fileprivate weak var delegate: PointViewDelegate?

    fileprivate let sections = PointSection.allCases
    fileprivate var pointsHistory: [PointHistoryModel] = []

    convenience init(delegate: PointViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: PointViewDelegate) {
        self.delegate = delegate
    }
}

extension PointPresenter {

    func loadPointHistory() {
        showHUDAndAllowUserInteractionEnabled()
        gateway.getPointHistory(success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            // Update user's point
            let userPoint = json[ResponseKey.data]["user_point"].intValue
            ShareManager.shared.currentUserDetail().point = userPoint

            guard let points = Mapper<PointHistoryModel>().mapArray(
                JSONObject: json[ResponseKey.data]["point_history"].arrayObject) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.pointsHistory = points

            weakSelf.delegate?.didLoadPointHistory()
        }, failure: nil)
    }
}

extension PointPresenter {

    var numberOfSections: Int {
        return sections.count
    }

    func sectionTitleAt(section: Int) -> String {
        guard section < numberOfSections else {
            return TSConstants.EMPTY_STRING
        }

        return sections[section].title
    }

    func numberOfRowsAt(section: Int) -> Int {
        let sectionType = PointSection(raw: section)
        switch sectionType {
        case .balance:
            return 1
        default:
            return numberOfPointsHistory
        }
    }

    func valueAt(indexPath: IndexPath) -> Any {
        let sectionType = PointSection(raw: indexPath.section)
        switch sectionType {
        case .balance:
            return "\(ShareManager.shared.currentUserDetail().getConvertedPoint()) P"
        default:
            let pointHistory = pointHistoryAt(row: indexPath.row)
            let isEarned = pointHistory.gaint_flg == .earn
            let color = isEarned ? ColorName.cC95851.color : ColorName.c333333.color

            var nameConfigs = lineHeightConfig(1.5, alignment: .left)
            nameConfigs[.font] = UIFont.regular(size: 16.0)
            nameConfigs[.foregroundColor] = ColorName.c333333.color
            let nameAttr = pointHistory.title.attributeString(configs: nameConfigs)

            let signed = isEarned ? "+" : "-"
            let pointStr = "\(signed)\(pointHistory.getConvertedPoint()) P"
            let pointValueAttr = pointStr.attributeString(configs: [
                .font: UIFont.medium(size: 14.0),
                .foregroundColor: color
            ])

            return (
                title: nameAttr,
                point: pointValueAttr
            )
        }
    }

    private var numberOfPointsHistory: Int {
        return pointsHistory.count
    }

    private func pointHistoryAt(row: Int) -> PointHistoryModel {
        guard row < numberOfPointsHistory else {
            return PointHistoryModel()
        }

        return pointsHistory[row]
    }
}
