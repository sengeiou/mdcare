//
//  Preferences.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

// DEVELOP NOTE: This file was created to manage all variables of NSUserDefaults

import Foundation
import SwiftyJSON
import ObjectMapper

// MARK: - Identify User Default - KEY

// Token
private let globalUserToken = "global.user.token"
private let currentLanguageKey = "LCLCurrentLanguageKey"
private let globalDeviceToken = "global.device.token"
private let globalUserId = "global.user.id"

class Preferences {

    let kvoStore = UserDefaults.standard

    // MARK: - Language

    var didSetLanguageManually: Bool {
        return kvoStore.object(forKey: currentLanguageKey) != nil
    }

    // MARK: - Login

    var isLoggedIn: Bool {
        guard let token = getUserToken(), !token.isEmpty else {
            removeUserToken()

            return false
        }

        return true
    }

    func updateUser(token: String?) {
        guard let token = token, !token.isEmpty else {
            removeUserToken()

            return
        }

        kvoStore.set(token, forKey: globalUserToken)
        kvoStore.synchronize()
    }

    func getUserToken() -> String? {
        guard let token = kvoStore.object(forKey: globalUserToken) as? String,
            !token.isEmpty else {
                return nil
        }

        return token
    }

    func removeUserToken() {
        kvoStore.removeObject(forKey: globalUserToken)
        kvoStore.synchronize()
    }

    func updateDeviceToken(token: Data?) {
        guard let token = token, !token.isEmpty else {
            removeDeviceToken()

            return
        }

        kvoStore.set(token, forKey: globalDeviceToken)
        kvoStore.synchronize()
    }

    func getDeviceToken() -> Data? {
        guard let token = kvoStore.object(forKey: globalDeviceToken) as? Data,
            !token.isEmpty else {
                return nil
        }

        return token
    }

    func removeDeviceToken() {
        kvoStore.removeObject(forKey: globalDeviceToken)
        kvoStore.synchronize()
    }

    func updateUserId(userId: Int?) {
        guard let userId = userId else {
            removeUserId()

            return
        }

        kvoStore.set(userId, forKey: globalUserId)
        kvoStore.synchronize()
    }

    func getUserId() -> Int? {
        guard let userId = kvoStore.object(forKey: globalUserId) as? Int else {
            return nil
        }

        return userId
    }

    func removeUserId() {
        kvoStore.removeObject(forKey: globalUserId)
        kvoStore.synchronize()
    }
}
