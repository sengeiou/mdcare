//
//  PresentApplicationSummaryRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol PresentApplicationSummaryRoute {
    var openPresentApplicationSummaryTransition: Transition { get }
    func openPresentApplicationSummary(id: Int,
                                       questions: [QuestionModel]?,
                                       userDetail: UserDetailModel)
}

extension PresentApplicationSummaryRoute where Self: RouterProtocol {

    var openPresentApplicationSummaryTransition: Transition {
        return PushTransition()
    }

    func openPresentApplicationSummary(id: Int,
                                       questions: [QuestionModel]? = nil,
                                       userDetail: UserDetailModel) {
        let router = PresentApplicationSummaryRouter()
        let presentApplicationSummaryViewController = PresentApplicationSummaryViewController.newInstance().then {
            $0.set(router: router)
            $0.set(presentId: id)
            $0.set(questions: questions)
            $0.set(userDetail: userDetail)
        }
        router.viewController = presentApplicationSummaryViewController

        let transition = openPresentApplicationSummaryTransition
        router.openTransition = transition
        open(presentApplicationSummaryViewController, transition: transition)
    }
}
