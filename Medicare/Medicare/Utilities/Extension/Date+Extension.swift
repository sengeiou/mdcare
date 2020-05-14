//
//  Date+Extension.swift
//  Medicare
//
//  Created by sanghv on 11/13/19.
//

import Foundation
import DateToolsSwift

extension Date {

    func startOfDay() -> Date {
        return self.start(of: .day)
    }

    func endOfDay() -> Date {
        return self.end(of: .day)
    }

    func nextOfDay() -> Date {
        return self.addingTimeInterval(Constants.SecondsInDay)
    }

    func nextOf(days: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(days) * Constants.SecondsInDay)
    }
}
