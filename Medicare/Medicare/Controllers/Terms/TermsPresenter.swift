//
//  TermsPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol TermsViewDelegate: class {

}

final class TermsPresenter {

    fileprivate weak var delegate: TermsViewDelegate?

    convenience init(delegate: TermsViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: TermsViewDelegate) {
        self.delegate = delegate
    }
}

extension TermsPresenter {

    func getEmptyTermUrl() -> URL? {
        guard let url = R.file.emptyWebviewHtml() else {
            return nil
        }

        return url
    }
}
