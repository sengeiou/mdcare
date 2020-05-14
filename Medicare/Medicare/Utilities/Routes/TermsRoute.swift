//
//  TermsRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation
import UIKit

protocol TermsRoute {
    var openTermsTransition: Transition { get }
    func openTerms(url: URL?, title: String)
}

extension TermsRoute where Self: RouterProtocol {

    var openTermsTransition: Transition {
        return PushTransition()
    }

    func openTerms(url: URL?, title: String) {
        let router = TermsRouter()
        let termsViewController = TermsViewController.newInstance().then {
            $0.set(router: router)
            $0.url = url
            $0.title = title
        }
        router.viewController = termsViewController

        let transition = openTermsTransition
        router.openTransition = transition
        open(termsViewController, transition: transition)
    }
}
