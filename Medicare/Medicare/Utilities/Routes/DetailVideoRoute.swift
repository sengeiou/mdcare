//
//  DetailVideoRoute.swift
//  Medicare
//
//  Created by Thuan on 3/10/20.
//

import Foundation

protocol DetailVideoRoute {
    func openVideoDetailView(_ video: VideoModel?)
}

extension DetailVideoRoute where Self: RouterProtocol {

    func openVideoDetailView(_ video: VideoModel?) {
        let router = DetailVideoRouter()
        let detailViewController = DetailVideoViewController.newInstance().then {
            $0.route = router
            $0.video = video
        }
        router.viewController = detailViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(detailViewController, transition: trans)
    }
}
