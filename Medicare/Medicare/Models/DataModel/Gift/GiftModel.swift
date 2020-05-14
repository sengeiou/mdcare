//
//  GiftModel.swift
//  Medicare
//
//  Created by Thuan on 3/16/20.
//

import Foundation
import ObjectMapper

struct GiftModelKey {
    static let present_question = "present_question"
}

enum GiftStatus {
    case alreadyApplicant, pointNotEnough, requiredInfo, availability
}

final class GiftModel: BaseModel {

    // MARK: - Properties

    var title: String?
    var img_path: URL?
    var detail: String?
    var notes: String?
    var start_at: String?
    var end_at: String?
    var point: Int?
    var prizewinner_count: Int?
    var created_at: String?
    var present_supplementary: [GiftSupplementaryModel]?
    var present_question: [QuestionModel] = []
    var type: String?
    var applicant_flg: Bool?

    var group: String?
    var hasHeader = false

    var haveQuestions: Bool {
        return !present_question.isEmpty
    }

    // MARK: - Map

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.title          <- map["title"]
        self.img_path       <- (map["img_path"], URLTransform())
        self.detail         <- map["detail"]
        self.notes          <- map["notes"]
        self.start_at       <- map["start_at"]
        self.end_at         <- map["end_at"]
        self.point          <- (map["point"], IntTransform())
        self.prizewinner_count     <- (map["prizewinner_count"], IntTransform())
        self.created_at     <- map["created_at"]
        self.present_supplementary     <- map["present_supplementary"]
        self.present_question   <- map[GiftModelKey.present_question]
        self.type   <- map["type"]
        self.applicant_flg  <- (map["applicant_flg"], BoolTransform())
    }

    func getPeriod() -> String {
        if let start_at = start_at, let end_at = end_at,
            let startDate = yyyyMMddHHmmssWithDashDateColonTimeFormatter.date(from: start_at),
            let endDate = yyyyMMddHHmmssWithDashDateColonTimeFormatter.date(from: end_at) {
            return "\(yyyyMMddJPFormatter.string(from: startDate))〜\(yyyyMMddJPFormatter.string(from: endDate))"
        }
        return ""
    }

    var isMember: Bool {
        return type == "2"
    }
}

extension GiftModel: MediaProtocol {

    var name: String {
        return title ?? TSConstants.EMPTY_STRING
    }

    var imageUrl: URL? {
        return img_path
    }
}
