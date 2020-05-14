//
//  TargetType.swift
//  Medicare
//
//  Created by sanghv on 2/22/20.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire

private let oauthUsername = "nstaff"
private let oauthPassword = "vCubeCm1"

public var basicAuthorization: String {
    let passwordString = "\(oauthUsername):\(oauthPassword)"
    let passwordData = passwordString.data(using: .utf8)
    let base64EncodedCredential = passwordData?.base64EncodedString(options: .lineLength64Characters)

    if let base64EncodedCredential = base64EncodedCredential {
        let authString = "Basic \(base64EncodedCredential)"
        return authString
    }

    return ""
}

/** TargetType protocol

*/
public protocol TargetType: Moya.TargetType {

}

extension TargetType {

    public var baseURL: URL {
        /*
        return URL(string: Configuration.shared.environment.apiHost
            + TSConstants.SLASH_STRING
            + Configuration.shared.environment.apiVersion)!
        */
        return URL(string: Configuration.shared.environment.apiHost)!
    }

    public var headers: [String: String]? {
        var headers: [String: String] = [:]

        // Authorization
        // swiftlint:disable:next line_length
//        prefs?.updateUser(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MTAsInR5cGUiOiIxIiwic3RhdHVzIjoiMSIsImxhc3RfbG9naW4iOm51bGwsInNtc19yZXF1ZXN0X2lkIjoiOGUxMzI1YjY2MmM3NGQ2YmJjNjM5ZmRiNGIzNzgwZGQiLCJyZXNpZ25lZF9hdCI6bnVsbCwiY3JlYXRlZF9hdCI6IjIwMjAtMDQtMDYgMjI6MTc6MzMiLCJ1cGRhdGVkX2F0IjoiMjAyMC0wNC0wNyAxMzowMzowMiIsImRlbGV0ZWRfYXQiOm51bGx9.rEwoJbOrtlYEDvAL5E1MFJhNiIcVTfc2DDn7HXFQFHM")
        // swiftlint:disable:end line_length
        if let accessToken = prefs?.getUserToken() {
            headers["access-token"] = accessToken
        }
        headers["Authorization"] = basicAuthorization
        headers["api-key"] = "meri"
        headers["app-version"] = appVersion
        headers["os"] = ConfigOS.iOS.rawValue

        return headers
    }

    public var sampleData: Data {
        return Data()
    }

    public func multipartTaskFrom(_ dictionary: [String: Any]) -> Task {
        var params: [Moya.MultipartFormData] = []
        for (key, value) in dictionary {
            var rawData: Data?
            if let value = value as? Int {
                rawData = value.toString().data(using: .utf8)
            } else if let value = value as? String {
                rawData = value.data(using: .utf8)
            } else if let value = value as? [String: Any] {
                rawData = try? JSON(value).rawData()
            } else if let value = value as? [[String: Any]] {
                rawData = try? JSON(value).rawData()
            }

            guard let data = rawData else {
                continue
            }

            let formData = MultipartFormData(
                provider: .data(data),
                name: key
            )
            params.append(formData)
        }

        let task = Task.uploadMultipart(params)

        return task
    }
}
