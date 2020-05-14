//
//  FirstViewRoute.swift
//  Medicare
//
//  Created by sanghv on 1/3/20.
//

import Foundation

protocol FirstViewRoute {
    func openFirstView()
}

extension FirstViewRoute where Self: RouterProtocol {

    func openFirstView() {
        let firstVC = FirstViewController.newInstance()
        let navVC = UINavigationController(rootViewController: firstVC)
        navVC.setAsRootVCAnimated()
    }
}
