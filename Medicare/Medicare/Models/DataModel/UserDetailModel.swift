//
//  UserDetailModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct UserDetailModelKey {
    static let id             = "id"
    static let user_id        = "user_id"
    static let last_name      = "last_name"
    static let first_name     = "first_name"
    static let last_furigana  = "last_furigana"
    static let first_furigana = "first_furigana"
    static let age            = "age"
    static let birthday       = "birthday"
    static let gender         = "gender"
    static let zipcode        = "zipcode"
    static let prefecture     = "prefecture"
    static let city           = "city"
    static let address        = "address"
    static let tel_no         = "tel_no"
    static let permit         = "permit"
    static let point          = "point"
    static let last_point_at  = "last_point_at"
    static let push_flg       = "push_flg"
    static let building       = "building"
}

final class UserDetailModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var user_id        : Int    = 0
    var last_name      : String = TSConstants.EMPTY_STRING
    var first_name     : String = TSConstants.EMPTY_STRING
    var last_furigana  : String = TSConstants.EMPTY_STRING
    var first_furigana : String = TSConstants.EMPTY_STRING
    var age            : String = TSConstants.EMPTY_STRING
    var birthday       : String = TSConstants.EMPTY_STRING
    var gender         : Gender = .unknown
    var zipcode        : String = TSConstants.EMPTY_STRING
    var prefecture     : Int    = 0
    var city           : String = TSConstants.EMPTY_STRING
    var address        : String = TSConstants.EMPTY_STRING
    var tel_no         : String = TSConstants.EMPTY_STRING
    var permit         : Int    = 0
    var point          : Int    = 0
    var last_point_at  : String = TSConstants.EMPTY_STRING
    var push_flg       : Int    = 0
    var building       : String = TSConstants.EMPTY_STRING
    // swiftlint:enable colon

    func getConvertedPoint() -> String {
        return groupNumberFormatter.string(for: point) ?? TSConstants.ZERO_STRING
    }

    var birthdayInDate: Date? {
        get {
            return yyyyMMddFormatter.date(from: birthday)
        }
        set {
            if let newValue = newValue {
                birthday = yyyyMMddFormatter.string(from: newValue)
            } else {
                birthday = TSConstants.EMPTY_STRING
            }
        }
    }

    var birthdayForDisplaying: String {
        guard let date = birthdayInDate else {
            return TSConstants.EMPTY_STRING
        }

        return yyyyMMddWithSlashFormatter.string(from: date)
    }

    /*
    var isRegisteredInfo: Bool {
        return hasFullName
    }
    */

    var isOpenPush: Bool {
        return push_flg == 1
    }

    var hasFullName: Bool {
        return !last_name.trim().isEmpty
            && !first_name.trim().isEmpty
    }

    var hasFullNameKana: Bool {
        return !last_furigana.trim().isEmpty
            && !first_furigana.trim().isEmpty
    }

    var isFullNameKana: Bool {
        guard hasFullNameKana else {
            return false
        }

        return last_furigana.trim().isKatakana
            && first_furigana.trim().isKatakana
    }

    var hasGender: Bool {
        return gender != .unknown
    }

    var hasBirthday: Bool {
        return !birthday.trim().isEmpty
    }

    var hasPhone: Bool {
        return !tel_no.trim().isEmpty
    }

    var hasZipcode: Bool {
        return zipcode.trim().count >= NumberConstant.zipcodeLength
    }

    var hasPrefecture: Bool {
        return prefecture != 0
    }

    var hasCity: Bool {
        return !city.trim().isEmpty
    }

    var hasAddress: Bool {
        return !address.trim().isEmpty
    }

    var hasBuilding: Bool {
        return !building.trim().isEmpty
    }

    var hasFullAddress: Bool {
        return hasZipcode
            && hasPrefecture
            && hasCity
            && hasAddress
    }

    var fullName: String {
        return "\(last_name) \(first_name)"
    }

    var fullNameKana: String {
        return "\(last_furigana) \(first_furigana)"
    }

    var fullAddress: String {
        let prefectureName = ShareManager.shared.prefectureAt(index: prefecture)
        return "〒\(zipcode) \(prefectureName) \(city) \(address) \(building)"
    }

    var magazineSubscribed: Bool {
        return permit == 1
    }

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.user_id        <- (map[UserDetailModelKey.user_id], IntTransform())
        self.last_name      <- map[UserDetailModelKey.last_name]
        self.first_name     <- map[UserDetailModelKey.first_name]
        self.last_furigana  <- map[UserDetailModelKey.last_furigana]
        self.first_furigana <- map[UserDetailModelKey.first_furigana]
        self.age            <- map[UserDetailModelKey.age]
        self.birthday       <- map[UserDetailModelKey.birthday]
        self.gender         <- map[UserDetailModelKey.gender]
        self.zipcode        <- map[UserDetailModelKey.zipcode]
        self.prefecture     <- (map[UserDetailModelKey.prefecture], IntTransform())
        self.city           <- map[UserDetailModelKey.city]
        self.address        <- map[UserDetailModelKey.address]
        self.tel_no         <- map[UserDetailModelKey.tel_no]
        self.permit         <- (map[UserDetailModelKey.permit], IntTransform())
        self.point          <- (map[UserDetailModelKey.point], IntTransform())
        self.last_point_at  <- map[UserDetailModelKey.last_point_at]
        self.push_flg       <- (map[UserDetailModelKey.push_flg], IntTransform())
        self.building       <- map[UserDetailModelKey.building]
    }
}
