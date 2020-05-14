//
//  SplashViewController.swift
//  Medicare
//
//  Created by Thuan on 3/2/20.
//

import UIKit

final class SplashViewController: BaseViewController {

    // MARK: Variables

    fileprivate let route = SplashRouter()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SplashViewController {

    override func configView() {
        super.configView()

        if let userId = prefs?.getUserId() {
            updateDeviceTokenToCloud(userId)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.switchView()
        }
    }

    override func reloadLocalizedViews() {
        super.reloadLocalizedViews()
    }
}

extension SplashViewController {

    fileprivate func switchView() {
        if prefs?.getUserToken() != nil {
            openHome()
            return
        }
        route.openFirstView()
//        openHome()
    }

    fileprivate func openHome() {
        TabBarController().setAsRootVCAnimated()
    }
}
