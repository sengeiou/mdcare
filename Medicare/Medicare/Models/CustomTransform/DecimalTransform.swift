//
//  DecimalTransform.swift
//  Medicare
//
//  Created by sanghv on 1/1/20.
//

import Foundation
import ObjectMapper

final class DecimalTransform: TransformType {
    typealias Object = Decimal
    typealias JSON = String

    init() {}

    func transformFromJSON(_ value: Any?) -> Decimal? {
        if let double = value as? Double {
            let decimalValue = Decimal(double)

            return decimalValue
        } else if let string = value as? String {
            return decimalForTransformFormatter.number(from: string)?.decimalValue
        }

        return nil
    }

    func transformToJSON(_ value: Decimal?) -> String? {
        if let decimal = value {
            return decimalForTransformFormatter.string(for: decimal)
        }

        return nil
    }
}
