//
//  ShareManager.swift
//  Medicare
//
//  Created by sanghv on 3/12/19.
//

import Foundation
import SwiftyJSON

/** ShareManager Class

*/
final class ShareManager {

    static let shared = ShareManager()

    var currentHomePage = false
    fileprivate(set) var currentUser = UserModel()
    fileprivate(set) lazy var currentUserDetail: () -> UserDetailModel = { [weak self] in
        guard let weakSelf = self else {
            return UserDetailModel()
        }

        return weakSelf.currentUser.user_detail
    }
    fileprivate(set) var prefectures: [String] = []

    private init() {
        commonInit()
    }

    private func commonInit() {
        loadPrefecture()
    }
}

// MARK: - User

extension ShareManager {

    func setCurentUser(_ user: UserModel) {
        currentUser = user
    }

    func setCurentUserDetail(_ userDetail: UserDetailModel) {
        currentUser.user_detail = userDetail
    }
}

// Prefecture

extension ShareManager {

    private func loadPrefecture() {
        guard let jsonUrl = R.file.prefecturesListJson() else {
            return
        }

        guard let data = FileManagerHelper.shared.getContentsOf(jsonUrl) else {
            return
        }

        prefectures = (JSON(rawValue: data)?[ResponseKey.data].arrayObject as? [String]) ?? []
    }

    private var numberOfPrefectures: Int {
        return prefectures.count
    }

    func prefectureAt(index: Int) -> String {
        guard index < numberOfPrefectures
            && index != 0 else {
                return TSConstants.EMPTY_STRING
        }

        return prefectures[index]
    }
}
