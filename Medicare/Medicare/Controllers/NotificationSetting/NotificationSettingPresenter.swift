//
//  NotificationSettingPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol NotificationSettingPresenterDelegate: class {
    func getUserInfoCompleted()
    func changeStatusCompleted(_ error: String?)
}

class NotificationSettingPresenter {

    weak var delegate: NotificationSettingPresenterDelegate?

    func getUserInfo() {
        showHUDAndAllowUserInteractionEnabled()
        AuthenticationGateway().getUserInfo(success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let user = Mapper<UserModel>().map(JSONObject: json[ResponseKey.data].dictionaryObject) else {
                return
            }

            ShareManager.shared.setCurentUser(user)
            self?.delegate?.getUserInfoCompleted()
        }, failure: nil)
    }

    func changeStatus(_ setting: Int) {
        showHUDActivity()
        let gateWay = UserGateway()
        gateWay.settingNotification(setting, success: { [weak self] (_) in
            popHUDActivity()
            self?.delegate?.changeStatusCompleted(nil)
        }, failure: { [weak self] (error) in
            self?.delegate?.changeStatusCompleted(error)
        })
    }
}
