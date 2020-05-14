//
//  QuestionModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct QuestionModelKey {
    static let id         = "id"
    static let present_id = "present_id"
    static let content    = "content"
    static let type       = "type"
    static let items      = "present_question_item"
}

enum QuestionType: String {
    case single = "1", multiple = "2", input = "3"
}

final class QuestionModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var present_id : Int           = 0
    var content    : String        = TSConstants.EMPTY_STRING
    var type       : QuestionType  = .input
    var items      : [AnswerModel] = [] {
        didSet {
            items.forEach {
                $0.questionType = type
            }
        }
    }
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.present_id <- (map[QuestionModelKey.present_id], IntTransform())
        self.content    <- map[QuestionModelKey.content]
        self.type       <- map[QuestionModelKey.type]
        self.items      <- map[QuestionModelKey.items]
    }
}
