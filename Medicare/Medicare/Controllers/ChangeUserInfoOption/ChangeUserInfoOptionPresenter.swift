//
//  ChangeUserInfoOptionPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol ChangeUserInfoOptionViewDelegate: UserInfoViewDelegate {

}

final class ChangeUserInfoOptionPresenter: UserInfoPresenter {

    fileprivate weak var delegate: ChangeUserInfoOptionViewDelegate?

    fileprivate let sections = ChangeUserInfoOptionSection.allCases
    fileprivate let options = ChangeUserInfoOptionRow.allCases

    convenience init(delegate: ChangeUserInfoOptionViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: ChangeUserInfoOptionViewDelegate) {
        super.set(delegate: delegate)
        self.delegate = delegate
    }
}

extension ChangeUserInfoOptionPresenter {

    var numberOfSections: Int {
        return sections.count
    }

    func sectionTitleAt(section: Int) -> String {
        guard section < numberOfSections else {
            return TSConstants.EMPTY_STRING
        }

        return sections[section].title
    }

    func numberOfRowsAt(section: Int) -> Int {
        let sectionType = ChangeUserInfoOptionSection(raw: section)
        switch sectionType {
        case .option:
            return numberOfRowsOptions
        }
    }

    func valueAt(indexPath: IndexPath) -> Any {
        let sectionType = ChangeUserInfoOptionSection(raw: indexPath.section)
        switch sectionType {
        case .option:
            return optionAt(row: indexPath.row)
        }
    }

    private var numberOfRowsOptions: Int {
        return options.count
    }

    private func optionAt(row: Int) -> (String, String) {
        guard row < numberOfRowsOptions else {
            return (TSConstants.EMPTY_STRING, TSConstants.EMPTY_STRING)
        }

        let item = options[row]

        return (item.title, TSConstants.EMPTY_STRING)
    }
}
