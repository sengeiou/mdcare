//
//  Int+Extension.swift
//  Medicare
//
//  Created by sanghv on 2/19/20.
//

import Foundation

extension Int {

    func toString() -> String {
        return "\(self)"
    }

    func toIndexSet() -> IndexSet {
        return IndexSet(integer: self)
    }

    var boolValue: Bool {
        return self != 0
    }
}
