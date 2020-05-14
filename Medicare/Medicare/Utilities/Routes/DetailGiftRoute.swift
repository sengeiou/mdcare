//
//  DetailGiftRoute.swift
//  Medicare
//
//  Created by Thuan on 3/12/20.
//

import Foundation

protocol DetailGiftRoute {
    func openGiftDetailView(_ gift: GiftModel?)
}

extension DetailGiftRoute where Self: RouterProtocol {

    func openGiftDetailView(_ gift: GiftModel?) {
        let router = DetailGiftRouter()
        let detailViewController = DetailGiftViewController.newInstance().then {
            $0.route = router
            $0.gift = gift
        }
        router.viewController = detailViewController
        let trans = PushTransition()
        router.openTransition = trans
        open(detailViewController, transition: trans)
    }
}
