//
//  UserInfoPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON

public typealias GetUserInfoSuccessClosure = (() -> Void)
public typealias UpdateUserInfoSuccessClosure = ((Any) -> Void)

protocol UserInfoViewDelegate: class {
    func didLoadPrefecture()
    func didSearchZipcodeInfo()
    func didGetUserInfo()
    func didUpdateUserInfo()
}

extension UserInfoViewDelegate {

    func didLoadPrefecture() {

    }

    func didSearchZipcodeInfo() {

    }

    func didGetUserInfo() {

    }

    func didUpdateUserInfo() {

    }
}

class UserInfoPresenter {

    fileprivate let gateway = AuthenticationGateway()
    fileprivate weak var delegate: UserInfoViewDelegate?

    fileprivate var prefecturesList: [String] = []
    fileprivate var gendersList: [Gender] = Gender.allCases
    fileprivate var selectRow: Int?

    private(set) var tempUserDetail: UserDetailModel = UserDetailModel()

    convenience init(delegate: UserInfoViewDelegate) {
        self.init()
        self.delegate = delegate
    }

    func set(delegate: UserInfoViewDelegate) {
        self.delegate = delegate
    }

    func setTempUserDetail(_ userDetail: UserDetailModel) {
        tempUserDetail = userDetail
    }
}

extension UserInfoPresenter {

    func loadPrefecture() {
        prefecturesList = ShareManager.shared.prefectures
        delegate?.didLoadPrefecture()
    }
}

extension UserInfoPresenter {

    func getUserInfo() {
        showHUDAndAllowUserInteractionEnabled()
        gateway.getUserInfo(success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let user = Mapper<UserModel>().map(JSONObject: json[ResponseKey.data].dictionaryObject) else {
                return
            }

            guard let weakSelf = self else {
                return
            }

            ShareManager.shared.setCurentUser(user)

            let newUserDetail = Mapper<UserDetailModel>().map(
                JSONObject: user.user_detail.toJSON(),
                toObject: UserDetailModel()
            )
            weakSelf.setTempUserDetail(newUserDetail)

            weakSelf.delegate?.didGetUserInfo()
        }, failure: nil)
    }

    func updateUser(updateMagazineSubscription: Bool = false,
                    forceUpdateMagazineSubscription: Bool = false) {
        var data = tempUserDetail.toJSON()
        if forceUpdateMagazineSubscription {
            data[UserDetailModelKey.permit] = 1
        } else if updateMagazineSubscription {
            let permit = tempUserDetail.permit
            data[UserDetailModelKey.permit] = (permit == 0) ? 1 : 0
        }
        updateUser(info: data, success: { user in
            guard let user = user as? UserModel else {
                return
            }

            ShareManager.shared.setCurentUser(user)
        })
    }

    func updateUser(info: [String: Any], success: UpdateUserInfoSuccessClosure? = nil) {
        showHUDAndAllowUserInteractionEnabled()
        gateway.updateUser(info: info, success: { [weak self] (response) in
            popHUDActivity()

            guard let weakSelf = self else {
                return
            }

            guard let json = response as? JSON else {
                return
            }

            guard let user = Mapper<UserModel>().map(JSONObject: json[ResponseKey.data].dictionaryObject) else {
                return
            }

            success?(user)
            weakSelf.delegate?.didUpdateUserInfo()
        }, failure: nil)
    }

    func search(zipcode: String) {
        showHUDAndAllowUserInteractionEnabled()
        ZipcodeGateway().search(zipcode: zipcode, success: { [weak self] (response) in
            popHUDActivity()

            guard let weakSelf = self else {
                return
            }

            guard let json = response as? JSON else {
                weakSelf.clearZipcodeInfoFromTempUserDetail()

                return
            }

            guard let zipcodeResults = Mapper<ZipcodeResultModel>()
                .mapArray(JSONObject: json[ResponseKey.data].arrayObject),
                let zipcodeResult = zipcodeResults.first else {
                    weakSelf.clearZipcodeInfoFromTempUserDetail()

                    return
            }

            weakSelf.updateTempUserDetailWith(zipcodeResult)
        }, failure: { [weak self] (_) in
            guard let weakSelf = self else {
                return
            }

            weakSelf.clearZipcodeInfoFromTempUserDetail()
        })
    }
}

extension UserInfoPresenter {

    private var numberOfGenders: Int {
        return gendersList.count
    }

    private func genderAt(row: Int) -> Gender {
        guard row < numberOfGenders else {
            return .unknown
        }

        return gendersList[row]
    }

    func getGenders() -> (selectRow: Int?, value: String, genders: [String]) {
        let gender = tempUserDetail.gender

        return (gender.index, gender.title, gendersList.map { $0.title })
    }

    private var numberOfPrefectures: Int {
        return prefecturesList.count
    }

    private func prefectureAt(row: Int) -> String {
        guard row < numberOfPrefectures else {
            return TSConstants.EMPTY_STRING
        }

        return prefecturesList[row]
    }

    func getPrefectures() -> (selectRow: Int?, value: String, prefectures: [String]) {
        let prefcode = tempUserDetail.prefecture
        let value: String
        if prefcode == 0 {
            value = R.string.localization.prefectures.localized()
        } else {
            value = prefectureAt(row: prefcode)
        }

        return (prefcode, value, prefecturesList)
    }

    private func updateTempUserDetailWith(_ zipcodeResult: ZipcodeResultModel) {
        tempUserDetail.zipcode = zipcodeResult.zipcode
        tempUserDetail.prefecture = Int(zipcodeResult.prefcode) ?? 0
        tempUserDetail.city = zipcodeResult.cityName
        tempUserDetail.address = zipcodeResult.townName
        delegate?.didSearchZipcodeInfo()
    }

    private func clearZipcodeInfoFromTempUserDetail() {
        tempUserDetail.zipcode = TSConstants.EMPTY_STRING
        tempUserDetail.prefecture = 0
        tempUserDetail.city = TSConstants.EMPTY_STRING
        tempUserDetail.address = TSConstants.EMPTY_STRING
        delegate?.didSearchZipcodeInfo()
    }

    func verifyUserInfoMessage() -> String? {
        guard tempUserDetail.hasFullName else {
            return R.string.localization.requiredField.localized()
        }

        guard tempUserDetail.isFullNameKana else {
            return R.string.localization.requiredField.localized()
        }

        guard tempUserDetail.hasGender else {
            return R.string.localization.requiredField.localized()
        }

        guard tempUserDetail.hasBirthday else {
            return R.string.localization.requiredField.localized()
        }

        guard tempUserDetail.hasPhone else {
            return R.string.localization.requiredField.localized()
        }

        guard tempUserDetail.hasFullAddress else {
            return R.string.localization.requiredField.localized()
        }

        return nil
    }

    func verifyFullNameMessage() -> String? {
        guard tempUserDetail.hasFullName else {
            return R.string.localization.pleaseEnterYourName.localized()
        }

        return nil
    }

    func verifyFullNameKanaMessage() -> String? {
        guard tempUserDetail.hasFullNameKana else {
            return R.string.localization.pleaseEnterYourKanaName.localized()
        }

        guard tempUserDetail.isFullNameKana else {
            return R.string.localization.pleaseInputInKatakana.localized()
        }

        return nil
    }

    func verifyGenderMessage() -> String? {
        guard tempUserDetail.hasGender else {
            return R.string.localization.pleaseSelectAGender.localized()
        }

        return nil
    }

    func verifyBirthdayMessage() -> String? {
        guard tempUserDetail.hasBirthday else {
            return R.string.localization.pleaseEnterYourDateOfBirth.localized()
        }

        return nil
    }

    func verifyPhoneMessage() -> String? {
        guard tempUserDetail.hasPhone else {
            return R.string.localization.pleaseEnterAPhoneNumber.localized()
        }

        return nil
    }

    func verifyZipcodeMessage() -> String? {
        guard tempUserDetail.hasZipcode else {
            return R.string.localization.thePostalCodeMustBeXCharacters.localized(
                [NumberConstant.zipcodeLength.toString()]
            )
        }

        return nil
    }

    func verifyPrefectureMessage() -> String? {
        guard tempUserDetail.hasPrefecture else {
            return R.string.localization.selectThePrefecture.localized()
        }

        return nil
    }

    func verifyCityMessage() -> String? {
        guard tempUserDetail.hasCity else {
            return R.string.localization.pleaseEnterACityName.localized()
        }

        return nil
    }

    func verifyAddressMessage() -> String? {
        guard tempUserDetail.hasAddress else {
            return R.string.localization.pleaseEnterTheAddressName.localized()
        }

        return nil
    }

//    func verifyBuildingMessage() -> String? {
//        guard tempUserDetail.hasBuilding else {
//            return R.string.localization.pleaseEnterTheBuildingName.localized()
//        }
//
//        return nil
//    }
}
