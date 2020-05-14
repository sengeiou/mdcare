//
//  QRScannerRouter.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

final class QRScannerRouter: Router<QRScannerViewController>, QRScannerRouter.Routes {
    typealias Routes = PresentApplicationRoute
        & PresentApplicationDoneRoute
}
