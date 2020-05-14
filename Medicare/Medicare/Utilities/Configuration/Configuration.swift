//
//  Configuration.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import UIKit

struct Configuration {

    static var shared = Configuration()

    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: Environment.prod.rawValue) != nil {
                return Environment.prod
            } else if configuration.range(of: Environment.qa.rawValue) != nil {
                return Environment.qa
            } else {
                return Environment.dev
            }
        }

        return Environment.dev
    }()
}
