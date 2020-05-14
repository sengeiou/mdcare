//
//  PresentApplicationPresenter.swift
//  Medicare
//
//  Created by sanghv on 12/31/19.
//

import Foundation
import ObjectMapper
import SwiftyJSON
import BEMCheckBox

protocol PresentApplicationViewDelegate: UserInfoViewDelegate {
    func didLoadQuestion()
}

extension PresentApplicationViewDelegate {

    func didLoadQuestion() {

    }
}

class PresentApplicationPresenter: UserInfoPresenter {

    fileprivate let gateway = PresentApplicationGateway()
    fileprivate weak var delegate: PresentApplicationViewDelegate?

    var presentId: Int = 0
    var questions: [QuestionModel] = []
    fileprivate var checkBoxGroups: [BEMCheckBoxGroup] = []

    convenience init(delegate: PresentApplicationViewDelegate) {
        self.init()
        super.set(delegate: delegate)
        self.delegate = delegate
    }

    func set(delegate: PresentApplicationViewDelegate) {
        super.set(delegate: delegate)
        self.delegate = delegate
    }
}

extension PresentApplicationPresenter {

    var isRegisteredUserInfo: Bool {
        return ShareManager.shared.currentUser.isRegisteredInfo
    }

    var isHasNoQuestions: Bool {
        return numberOfQuestions == 0
    }
}

extension PresentApplicationPresenter {

    func loadTempUserDetail() {
        let userDetail = ShareManager.shared.currentUserDetail()
        let newUserDetail = Mapper<UserDetailModel>().map(
            JSONObject: userDetail.toJSON(),
            toObject: UserDetailModel()
        )
        setTempUserDetail(newUserDetail)
        delegate?.didGetUserInfo()
    }

    /*
    func loadQuestions() {
        showHUDAndAllowUserInteractionEnabled()
        gateway.getQuestionOf(presentId: presentId, success: { [weak self] (response) in
            popHUDActivity()

            guard let json = response as? JSON else {
                return
            }

            guard let questions = Mapper<QuestionModel>().mapArray(
                JSONObject: json[ResponseKey.data].arrayObject) else {
                    return
            }

            guard let weakSelf = self else {
                return
            }

            weakSelf.questions = questions
            weakSelf.createCheckBoxGroups()

            weakSelf.delegate?.didLoadQuestion()
        }, failure: nil)
    }
    */
}

extension PresentApplicationPresenter {

    var numberOfQuestions: Int {
        return questions.count
    }

    func questionContentAt(section: Int) -> String {
        let question = questionAt(section: section)

        return "Q\(section+1).\(question.content)"
    }

    func questionTypeAt(section: Int) -> QuestionType {
        let question = questionAt(section: section)

        return question.type
    }

    private func questionAt(section: Int) -> QuestionModel {
        guard section < numberOfQuestions else {
            return QuestionModel()
        }

        return questions[section]
    }

    func numberOfAnswersAt(section: Int) -> Int {
        let question = questionAt(section: section)
        let questionType = question.type
        switch questionType {
        case .input:
            return 1
        default:
            return question.items.count
        }
    }

    func answerContentAt(indexPath: IndexPath) -> (String, Bool) {
        let question = questionAt(section: indexPath.section)
        let answer = answerAt(indexPath: indexPath)
        switch question.type {
        case .input:
            return (answer.present_question_content, false)
        default:
            return (answer.answer, answer.selected)
        }
    }

    func answerAt(indexPath: IndexPath) -> AnswerModel {
        let (section, row) = (indexPath.section, indexPath.row)
        let answers = questionAt(section: section).items
        guard row < answers.count else {
            return AnswerModel()
        }

        return answers[row]
    }

    func verifyAnswersMessage() -> String? {
        for question in questions {
            let type = question.type
            let noAnswer: [AnswerModel]
            switch type {
            case .input:
                noAnswer = question.items.filter {
                    return $0.present_question_content.trim().isEmpty
                }
            default:
                noAnswer = question.items.filter {
                    return !$0.selected
                }
            }

            guard noAnswer.count != question.items.count else {
                return R.string.localization.pleaseAnswerTheQuestionnaire.localized()
            }
        }

        return nil
    }
}

extension PresentApplicationPresenter {

    func createCheckBoxGroups() {
        var checkBoxGroups = [BEMCheckBoxGroup]()
        for _ in 0..<numberOfQuestions {
            let checkBoxGroup = BEMCheckBoxGroup().then {
                $0.mustHaveSelection = false
            }
            checkBoxGroups.append(checkBoxGroup)
        }

        self.checkBoxGroups = checkBoxGroups
    }

    private var numberOfCheckBoxGroups: Int {
        return checkBoxGroups.count
    }

    func checkBoxGroupAt(section: Int) -> BEMCheckBoxGroup? {
        guard section < numberOfCheckBoxGroups else {
            return nil
        }

        let questionType = questionTypeAt(section: section)
        switch questionType {
        case .single:
            return checkBoxGroups[section]
        default:
            return nil
        }
    }
}
