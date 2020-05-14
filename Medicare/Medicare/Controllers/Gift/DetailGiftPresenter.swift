//
//  DetailGiftPresenter.swift
//  Medicare
//
//  Created by Thuan on 3/28/20.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol DetailGiftPresenterDelegate: class {
    func getDetailCompleted(gift: GiftModel?, supplementaryItems: [GiftSupplementaryModel])
    func didApplicantPresent(_ message: String?)
}

final class DetailGiftPresenter {

    weak var delegate: DetailGiftPresenterDelegate?

    func getDetail(_ presentId: Int) {
        showHUDActivity()
        let gateWay = GiftGateway()
        gateWay.getPresentDetail(presentId) { [weak self] (response) in
            popHUDActivity()
            if let json = response as? JSON {
                let item = Mapper<GiftModel>().map(JSONString: json["data"].rawString() ?? "")
                self?.delegate?.getDetailCompleted(gift: item, supplementaryItems: item?.present_supplementary ?? [])
            }
        }
    }

    func getUserInfo(success: GetUserInfoSuccessClosure? = nil) {
        showHUDIfInvisible()
        AuthenticationGateway().getUserInfo(success: { (response) in
            dismissHUD()

            guard let json = response as? JSON else {
                return
            }

            guard let user = Mapper<UserModel>().map(JSONObject: json[ResponseKey.data].dictionaryObject) else {
                return
            }

            ShareManager.shared.setCurentUser(user)

            success?()
        }, failure: nil)
    }

    func applicantPresent(_ presentId: Int) {
        let data: [String: Any] = [:]
        showHUDAndAllowUserInteractionEnabled()
        PresentApplicationGateway().applicant(presentId: presentId, data: data, success: { [weak self] (_) in
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

extension DetailGiftPresenter {

    class func getStatusOf(gift: GiftModel) -> GiftStatus {
        let user = ShareManager.shared.currentUser
        let userDetail = ShareManager.shared.currentUserDetail()
        if let applicantFlg = gift.applicant_flg, applicantFlg == true {
            return .alreadyApplicant
        } else if let point = gift.point,
            userDetail.point < point {
            return .pointNotEnough
        } else if user.isRegisteredInfo
            && !gift.haveQuestions {
            return .availability
        } else {
            return .requiredInfo
        }
    }

    func cloneQuestionsFrom(_ questions: [QuestionModel]) -> [QuestionModel]? {
        for question in questions {
            guard question.type == .input else {
                continue
            }

            let answer = AnswerModel()
            answer.present_question_id = question.id
            question.items = [answer]
        }

        return Mapper<QuestionModel>().mapArray(JSONObject: questions.toJSON())
    }
}
