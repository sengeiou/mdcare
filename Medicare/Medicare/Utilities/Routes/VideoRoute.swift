//
//  VideoRoute.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

protocol VideoRoute {
    func openVideoView()
}

extension VideoRoute where Self: RouterProtocol {

    func openVideoView() {
        let router = VideoRouter()
        let videoViewController = VideoViewController.newInstance().then {
            $0.route = router
        }
        router.viewController = videoViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(videoViewController, transition: trans)
    }
}
