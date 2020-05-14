//
//  BoolTransform.swift
//  Medicare
//
//  Created by Thuan on 4/2/20.
//

import Foundation
import ObjectMapper

class BoolTransform: TransformType {

    typealias Object = Bool
    typealias JSON = String

    init() {}

    func transformFromJSON(_ value: Any?) -> Bool? {
        if let strValue = value as? String {
            return Int(strValue)?.boolValue
        } else if let intValue = value as? Int {
            return intValue.boolValue
        }
        return value as? Bool
    }

    func transformToJSON(_ value: Bool?) -> String? {
        if let intValue = value {
            return "\((intValue as NSNumber).intValue)"
        }
        return nil
    }
}
