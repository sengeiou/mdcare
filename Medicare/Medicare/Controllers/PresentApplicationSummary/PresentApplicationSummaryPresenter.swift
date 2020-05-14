//
//  PresentApplicationSummaryPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import BEMCheckBox

protocol PresentApplicationSummaryViewDelegate: PresentApplicationViewDelegate {
    func didApplicantPresent(_ message: String?)
}

final class PresentApplicationSummaryPresenter: PresentApplicationPresenter {

    fileprivate let gateway = PresentApplicationGateway()
    fileprivate weak var delegate: PresentApplicationSummaryViewDelegate?

    convenience init(delegate: PresentApplicationSummaryViewDelegate) {
        self.init()
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(delegate: PresentApplicationSummaryViewDelegate) {
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(questions originalQuestions: [QuestionModel]) {
        guard let clonedquestions = cloneQuestionsFrom(originalQuestions) else {
            return
        }

        for question in clonedquestions {
            question.items = question.items.filter {
                return $0.selected || !$0.present_question_content.isEmpty
            }
        }

        questions = clonedquestions
    }

    private func cloneQuestionsFrom(_ questions: [QuestionModel]) -> [QuestionModel]? {
        return Mapper<QuestionModel>().mapArray(JSONObject: questions.toJSON())
    }
}

extension PresentApplicationSummaryPresenter {

    private func getAnswersForApplicant() -> [String: Any] {
        var answers: [AnswerModel] = []
        for question in questions {
            answers.append(contentsOf: question.items)
        }

        answers = answers.filter {
            return $0.selected || !$0.present_question_content.isEmpty
        }

        let answersForApplicant = [ResponseKey.data: answers.map { $0.toJSONForApplicant() }]

        return answersForApplicant
    }

    func applicantPresent() {
        var data: [String: Any] = [:]

        if !isRegisteredUserInfo {
            data = tempUserDetail.toJSON()
            data[UserDetailModelKey.point] = nil
        }

        if !isHasNoQuestions {
            data["answer"] = getAnswersForApplicant()
        }

        showHUDAndAllowUserInteractionEnabled()
        gateway.applicant(presentId: presentId, data: data, success: { [weak self] (_) in
            popHUDActivity()

            guard let weakSelf = self else {
                return
            }

            weakSelf.delegate?.didApplicantPresent(nil)
        }, failure: { [weak self] (message) in
            guard let weakSelf = self else {
                return
            }

            weakSelf.delegate?.didApplicantPresent(message)
        })
    }
}
