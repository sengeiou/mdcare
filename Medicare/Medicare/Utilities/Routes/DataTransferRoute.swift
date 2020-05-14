//
//  DataTransferRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol DataTransferRoute {
    var openDataTransferTransition: Transition { get }
    func openDataTransfer()
}

extension DataTransferRoute where Self: RouterProtocol {

    var openDataTransferTransition: Transition {
        return PushTransition()
    }

    func openDataTransfer() {
        let router = DataTransferRouter()
        let dataTransferViewController = DataTransferViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = dataTransferViewController

        let transition = openDataTransferTransition
        router.openTransition = transition
        open(dataTransferViewController, transition: transition)
    }
}
