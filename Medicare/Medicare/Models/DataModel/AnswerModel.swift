//
//  AnswerModel.swift
//  Medicare
//
//  Created by sanghv on 12/23/19.
//

import Foundation
import ObjectMapper

struct AnswerModelKey {
    static let id                       = "id"
    static let present_question_item_id = "present_question_item_id"
    static let answer                   = "answer"
    static let value                    = "value"
    static let present_question_id      = "present_question_id"
    static let selected                 = "selected"
    static let present_question_content = "present_question_content"
}

final class AnswerModel: BaseModel {

    // MARK: - Properties
    // swiftlint:disable colon
    var present_question_item_id : Int?
    var answer                   : String = TSConstants.EMPTY_STRING
    var value                    : String = TSConstants.EMPTY_STRING
    var present_question_id      : Int?
    var selected                 : Bool   = false
    var present_question_content : String = TSConstants.EMPTY_STRING
    var questionType             : QuestionType  = .input
    // swiftlint:enable colon

    // MARK: - Map
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.present_question_item_id <- (map[AnswerModelKey.id], IntTransform())
        self.answer                   <- map[AnswerModelKey.answer]
        self.value                    <- map[AnswerModelKey.value]
        self.present_question_id      <- (map[AnswerModelKey.present_question_id], IntTransform())
        self.selected                 <- (map[AnswerModelKey.selected], BoolTransform())
        self.present_question_content <- map[AnswerModelKey.present_question_content]
    }

    func toJSONForApplicant() -> [String: Any] {
        var json = toJSON()
        switch questionType {
        case .input:
            json[AnswerModelKey.present_question_item_id] = nil
        default:
            json[AnswerModelKey.present_question_item_id] = id
            json[AnswerModelKey.present_question_content] = nil
        }

        let removeKeys = [
            AnswerModelKey.id,
            AnswerModelKey.answer,
            AnswerModelKey.value,
            AnswerModelKey.selected
        ]
        for key in removeKeys {
            json[key] = nil
        }

        return json
    }
}
