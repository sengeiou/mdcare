//
//  ChangePersonalInfoSummaryPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import BEMCheckBox

protocol ChangePersonalInfoSummaryViewDelegate: ChangePersonalInfoViewDelegate {

}

final class ChangePersonalInfoSummaryPresenter: ChangePersonalInfoPresenter {

    fileprivate weak var delegate: ChangePersonalInfoSummaryViewDelegate?

    convenience init(delegate: ChangePersonalInfoSummaryViewDelegate) {
        self.init()
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(delegate: ChangePersonalInfoSummaryViewDelegate) {
        super.set(delegate: delegate)
        self.delegate = delegate
    }
}
