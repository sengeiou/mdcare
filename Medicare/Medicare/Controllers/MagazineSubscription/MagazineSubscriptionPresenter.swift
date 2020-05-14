//
//  MagazineSubscriptionPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol MagazineSubscriptionViewDelegate: UserInfoViewDelegate {
    func loadMagazineIntroCompleted(_ url: URL?)
}

extension MagazineSubscriptionViewDelegate {
    func loadMagazineIntroCompleted(_ url: URL?) {}
}

final class MagazineSubscriptionPresenter: UserInfoPresenter {

    fileprivate weak var delegate: MagazineSubscriptionViewDelegate?

    convenience init(delegate: MagazineSubscriptionViewDelegate) {
        self.init()
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(delegate: MagazineSubscriptionViewDelegate) {
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func loadMagazineIntro() {
        let type = ConfigType.appBanner.rawValue
        let key = ConfigKey.magazineSubscribe.rawValue
        let gateWay = ConfigGateway()
        gateWay.getConfig(type: type,
                          key: key,
                          success: { [weak self] (response) in
                            if let json = response as? JSON {
                                let dataArr = Mapper<ConfigDataModel>().mapArray(JSONString:
                                    json["data"].rawString() ?? "")
                                let data = dataArr?.first(where: { $0.type == type
                                    && $0.key == key
                                    && $0.os == ConfigOS.iOS.rawValue })
                                self?.delegate?.loadMagazineIntroCompleted(data?.valueAsURL)
                            }
        }, failure: { [weak self] (_) in
            self?.delegate?.loadMagazineIntroCompleted(nil)
        })
    }
}
