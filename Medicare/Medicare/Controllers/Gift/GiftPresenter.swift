//
//  GiftPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol GiftPresenterDelegate: class {
    func loadDataCompleted(_ newestItems: [GiftModel], error: String?)
}

class GiftPresenter {

    weak var delegate: GiftPresenterDelegate?

    func loadData(pageSize: Int, pageIndex: Int, showHUD: Bool = true) {
        if showHUD {
            showHUDActivity()
        }
        let gateWay = GiftGateway()
        gateWay.getPresentList(pageSize: pageSize, pageIndex: pageIndex, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                if let data = json["data"].dictionaryObject {
                    let newestItems = Mapper<GiftModel>().mapArray(JSONObject: data["newest_present"])
                    self?.delegate?.loadDataCompleted(newestItems ?? [], error: nil)
                }
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.loadDataCompleted([], error: error)
        })
    }
}
