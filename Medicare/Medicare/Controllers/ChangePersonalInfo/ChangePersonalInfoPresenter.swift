//
//  ChangePersonalInfoPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol ChangePersonalInfoViewDelegate: UserInfoViewDelegate {
    func loadMagazineIntroCompleted(_ url: URL?)
}

extension ChangePersonalInfoViewDelegate {
    func loadMagazineIntroCompleted(_ url: URL?) {}
}

class ChangePersonalInfoPresenter: UserInfoPresenter {

    fileprivate weak var delegate: ChangePersonalInfoViewDelegate?

    convenience init(delegate: ChangePersonalInfoViewDelegate) {
        self.init()
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(delegate: ChangePersonalInfoViewDelegate) {
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
