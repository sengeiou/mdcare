//
//  SMSAuthenticationPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/25/20.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol SMSAuthenticationPresenterDelegate: class {
    func signinCompleted(_ request: UserAuthenticationModel?, error: String?)
    func signupCompleted(_ request: UserAuthenticationModel?, error: String?)
}

class SMSAuthenticationPresenter {

    weak var delegate: SMSAuthenticationPresenterDelegate?

    func signin(_ params: [String: Any]) {
        showHUDActivity()
        let gateWay = UserGateway()
        gateWay.signin(params, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let request = Mapper<UserAuthenticationModel>().map(JSONObject: json["data"].dictionaryObject)
                self?.delegate?.signinCompleted(request, error: nil)
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.signinCompleted(nil, error: error)
        })
    }

    func signup(_ params: [String: Any]) {
        showHUDActivity()
        let gateWay = UserGateway()
        gateWay.signup(params, success: { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let request = Mapper<UserAuthenticationModel>().map(JSONObject: json["data"].dictionaryObject)
                self?.delegate?.signupCompleted(request, error: nil)
            }
        }, failure: { [weak self] (error) in
            self?.delegate?.signupCompleted(nil, error: error)
        })
    }
}
