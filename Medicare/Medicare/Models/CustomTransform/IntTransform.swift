//
//  IntTransform.swift
//  Medicare
//
//  Created by Thuan on 4/2/20.
//

import Foundation
import ObjectMapper

class IntTransform: TransformType {

    typealias Object = Int
    typealias JSON = String

    init() {}

    func transformFromJSON(_ value: Any?) -> Int? {
        if let strValue = value as? String {
            return Int(strValue)
        } else if let boolValue = value as? Bool {
            return (boolValue as NSNumber).intValue
        }
        return value as? Int
    }

    func transformToJSON(_ value: Int?) -> String? {
        if let intValue = value {
            return "\(intValue)"
        }
        return nil
    }
}
