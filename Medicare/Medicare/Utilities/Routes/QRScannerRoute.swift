//
//  QRScannerRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol QRScannerRoute {
    var openQRScannerTransition: Transition { get }
    func openQRScanner()
}

extension QRScannerRoute where Self: RouterProtocol {

    var openQRScannerTransition: Transition {
        return PushTransition()
    }

    func openQRScanner() {
        let router = QRScannerRouter()
        let qrScannerViewController = QRScannerViewController.newInstance().then {
            $0.set(router: router)
        }
        router.viewController = qrScannerViewController

        let transition = openQRScannerTransition
        router.openTransition = transition
        open(qrScannerViewController, transition: transition)
    }
}
