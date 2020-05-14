//
//  DetailMagazinePresenter.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import ObjectMapper
import SwiftyJSON

enum PointGrantType: Int {
    case magazine = 1
    case video
    case event
}

protocol DetailMagazinePresenterDelegate: class {
    func likeCompleted(_ like: LikeModel?)
    func pointGrantCompleted(_ point: String)
}

class DetailMagazinePresenter: MagazineFeelingPresenter {

    weak var delegate: DetailMagazinePresenterDelegate?

    func pageView(_ magazineId: Int) {
        let gateWay = MagazineGateway()
        gateWay.pageView(magazineId)
    }

    func magazineLike(_ magazineId: Int?) {
        showHUDActivity()
        let gateway = MagazineGateway()
        gateway.like(magazineId ?? 0) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let like = Mapper<LikeModel>().map(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.likeCompleted(like)
            }
        }
    }

    func pointGrant(_ targetId: Int, type: PointGrantType) {
        showHUDActivity()
        let params: [String: Any] = [
            "target_id": targetId,
            "type": type.rawValue
        ]
        let gateWay = UserGateway()
        gateWay.pointGrant(params) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                var pointTemp: String = TSConstants.ZERO_STRING
                if let point = json[ResponseKey.data]["point"].rawValue as? Int {
                    pointTemp = point.toString()
                } else if let point = json[ResponseKey.data]["point"].rawValue as? String {
                    pointTemp = point
                }
                self?.delegate?.pointGrantCompleted(pointTemp)
            }
        }
    }
}
