//
//  PasswordGenerationPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol PasswordGenerationViewDelegate: class {

}

final class PasswordGenerationPresenter {

    fileprivate weak var delegate: PasswordGenerationViewDelegate?

    convenience init(delegate: PasswordGenerationViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: PasswordGenerationViewDelegate) {
        self.delegate = delegate
    }
}

extension PasswordGenerationPresenter {

}
