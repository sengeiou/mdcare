//
//  OTPAuthenticationPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/25/20.
//

import Foundation
import SwiftyJSON

protocol OTPAuthenticationPresenterDelegate: class {
    func otpValidateCompleted(error: String?)
}

class OTPAuthenticationPresenter {

    weak var delegate: OTPAuthenticationPresenterDelegate?
    var point = 0

    func otpValidate(_ params: [String: Any]) {
        showHUDActivity()
        let gateWay = UserGateway()
        gateWay.otpValidate(params, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                if let data = json["data"].dictionaryObject {
                    let accessToken = data["access_token"] as? String

                    var userIdTemp: Int?
                    if let id = data["user_id"] as? Int {
                        userIdTemp = id
                    } else if let id = data["user_id"] as? String {
                        userIdTemp = Int(id)
                    }

                    if let point = data["point"] as? Int {
                        self?.point = point
                    } else if let point = data["point"] as? String {
                        self?.point = Int(point) ?? 0

                    }
                    prefs?.updateUser(token: accessToken)
                    prefs?.updateUserId(userId: userIdTemp)
                    self?.delegate?.otpValidateCompleted(error: nil)
                }
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.otpValidateCompleted(error: error)
        })
    }
}
