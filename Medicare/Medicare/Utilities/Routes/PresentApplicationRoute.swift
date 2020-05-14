//
//  PresentApplicationRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol PresentApplicationRoute {
    var openPresentApplicationTransition: Transition { get }
    func openPresentApplication(id: Int, presentTitle: String?, questions: [QuestionModel]?)
}

extension PresentApplicationRoute where Self: RouterProtocol {

    var openPresentApplicationTransition: Transition {
        return PushTransition()
    }

    func openPresentApplication(id: Int, presentTitle: String? = nil, questions: [QuestionModel]? = nil) {
        let router = PresentApplicationRouter()
        let presentApplicationViewController = PresentApplicationViewController.newInstance().then {
            $0.set(router: router)
            $0.title = presentTitle
            $0.set(presentId: id)
            $0.set(questions: questions)
        }
        router.viewController = presentApplicationViewController

        let transition = openPresentApplicationTransition
        router.openTransition = transition
        open(presentApplicationViewController, transition: transition)
    }
}
